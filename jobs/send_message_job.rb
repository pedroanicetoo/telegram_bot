require_relative '../initializer'

scheduler = Rufus::Scheduler.new

# TODO: SETUP THIS SCHEDULER
scheduler.every '10m' do
  ChatActions::SendGif.new.call
end

scheduler.join