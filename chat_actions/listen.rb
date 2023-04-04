module ChatActions
  class Listen
  
    attr_reader :commands

    def initialize
      @commands ||= File.read('./commands.txt')
    end
  
    def start
      run_chat
    end
  
    private
  
    def run_chat
      Telegram::Bot::Client.run(API_TELEGRAM_KEY, logger: Logger.new($stderr)) do |bot|
        bot.listen do |message|
          case message.text
          when '/register'
            # bot.api.send_message(chat_id: message.chat.id, text: "Hello, #{message.from.first_name}") - reference
            # TODO 
          when '/unregister'
            # bot.api.send_message(chat_id: message.chat.id, text: "Bye, #{message.from.first_name}") - reference
            # TODO 
          else 
            bot.api.send_message(chat_id: message.chat.id, text: commands)
          end
        end
      end
    end

  end 
end