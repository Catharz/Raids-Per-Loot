require 'crack'
require 'httparty'

class SOEData
  include HTTParty
  base_uri 'data.soe.com'
end