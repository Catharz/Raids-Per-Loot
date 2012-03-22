require 'crack'
require 'httparty'

class SOEData
  include HTTParty
  base_uri 'data.soe.com'

  parser(
      Proc.new do |body, format|
        Crack::JSON::parse(body)
      end
  )
end