require 'rufus-scheduler'
require_relative '../send_gif'

scheduler = Rufus::Scheduler.new

scheduler.every '1m' do
  SendGif.new.call
end

scheduler.join
