require 'twitter'

client = Twitter::REST::Client.new do |config|
  config.consumer_key = ENV['TWITTER_CY']
  config.consumer_secret = ENV['TWITTER_CS']
  config.access_token = ENV['TWITTER_AT']
  config.access_token_secret = ENV['TWITTER_AS']
end