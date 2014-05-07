require 'twitter'

client = Twitter::REST::Client.new do |config|
  config.consumer_key = "ghMs9ik8TQDu27kW57jO6Q"
  config.consumer_secret = "cB9XPuFbHE34MY3BBtaPgZZc98wZjJYPoUxNI9eD6A"
  config.access_token = "231064535-vwBigkaaRPk48nftltRI6eria9LHT15T4wM9hbbD"
  config.access_token_secret = "Id6fihCFP08ndEwQ1VC3CYpR40UYyC4s83ykdYYQ8"
end