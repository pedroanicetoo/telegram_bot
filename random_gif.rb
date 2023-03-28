require 'net/http'
require 'json'
require 'dotenv/load'

BASE_URI = 'http://api.giphy.com/'
RANDOM_GIPHY = 'v1/gifs/random'
API_GIPHY_KEY = ENV['API_GIPHY_KEY']

class RandomGif

  attr_reader :tag

  def initialize(tag)
    @tag = tag
  end

  def self.call(*args)
    new(*args).call
  end

  def call
    return raise_unavailable_service_exception! if res.code.to_i >= 500

    JSON.parse(res.body).dig('data', 'images', 'original', 'mp4')
  end

  private

  def res
    @res ||= http.request(req)
  end

  def uri
    @uri ||= URI.parse("#{BASE_URI}#{RANDOM_GIPHY}?api_key=#{API_GIPHY_KEY}&tag=#{tag}")
  end

  def http
    @http ||= Net::HTTP.new(uri.host, uri.port)
  end

  def req
    @req ||= Net::HTTP::Get.new(uri)
  end

  def raise_unavailable_service_exception!
    raise 'unavailable_service'
  end

end