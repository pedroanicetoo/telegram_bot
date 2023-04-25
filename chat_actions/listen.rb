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
            answer_by_command(bot, message)
          end
        end
      end

      def welcome_message
        <<-MSG
          Olá, este são meus comandos:
          #{@commands}
        MSG
      end

      def answer_by_command(bot, message)
        return if message.class != Telegram::Bot::Types::Message
        return unless message.text

        if message.text.match?(/\gpt +/i)
          register_chat
          response = send_chat_gpt_message(message.text[5..])
          bot.api.send_message(chat_id: message.chat.id, text: response)
        end

        if message.text == '/help'
          bot.api.send_message(chat_id: message.chat.id, text: @commands)
        end

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
