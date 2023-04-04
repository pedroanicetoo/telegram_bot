Dir[File.dirname(__FILE__) + '/generators/*.rb'].each {|file| require file }
Dir[File.dirname(__FILE__) + '/chat_actions/*.rb'].each {|file| require file }
require 'dotenv/load'
require 'telegram/bot'
require 'net/http'
require 'rufus-scheduler'
require 'pry'

BASE_URI = 'http://api.giphy.com/'
RANDOM_GIPHY = 'v1/gifs/random'
CHAT_ID = ENV['CHAT_ID']
API_GIPHY_KEY = ENV['API_GIPHY_KEY']
API_TELEGRAM_KEY = ENV['API_TELEGRAM_KEY']