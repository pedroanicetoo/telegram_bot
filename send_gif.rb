require_relative 'random_gif'
require 'dotenv/load'
require 'telegram/bot'

API_TELEGRAM_KEY = ENV['API_TELEGRAM_KEY']
CHAT_ID = ENV['CHAT_ID']

class SendGif
  attr_accessor :gif_uri

  def initialize
    @gif_uri = request_gif_uri
  end

  def call
    send_message_to_chat
  end

  private

  def request_gif_uri
    RandomGif.call('the-office')
  end

  def send_message_to_chat
    Telegram::Bot::Client.run(API_TELEGRAM_KEY, logger: Logger.new($stderr)) do |bot|
      bot.logger.info('Bot has been started')
      bot.api.send_animation(chat_id: CHAT_ID, animation: gif_uri)
    end
  end
end