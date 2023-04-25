module ChatActions
  class Listen

    def self.start
      @commands ||= File.read('./commands.txt')
      run_bot
    end

    class << self
      private

      def run_bot
        Telegram::Bot::Client.run(API_TELEGRAM_KEY, logger: Logger.new($stderr)) do |bot|
          bot.listen do |message|

            case message
            when Telegram::Bot::Types::Message
              if message.new_chat_members &&
                 message.new_chat_members.map(&:id).include?(bot.api.get_me['result']['id'])
                bot.api.send_message(chat_id: message.chat.id, text: welcome_message)
              end
              answer_by_command(bot, message)
            else
              # do nothing
            end
          end
        end
      end

      def welcome_message
        "Olá, este são meus comandos:\n#{@commands}"
      end

      def answer_by_command(bot, message)
        return unless message.text

        case message.text
        when '/help'
          bot.api.send_message(chat_id: message.chat.id, text: @commands)
        else
          complex_commands(message)
        end
      end

      def welcome_message
        "Olá, esses são meus comandos:\n#{@commands}"
      end

      def complex_commands(message)
        return unless message.text.match?(/\gpt +/i)

        register_chat
        response = send_chat_gpt_message(message.text[5..])
        bot.api.send_message(chat_id: message.chat.id, text: response)
      end

      def register_chat
        return if @client

        @client ||= OpenAI::Client.new(access_token: API_OPENAI_KEY)
      end

      def send_chat_gpt_message(question)
        response = @client.chat(
          parameters: {
            model: "gpt-3.5-turbo",
            messages: [{ role: "user", content: question}], # Required.
            temperature: 0.7,
        })
        response.dig("choices", 0, "message", "content")
      end

    end
  end
end
