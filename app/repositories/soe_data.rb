require 'crack'
require 'httparty'

# @author Craig Read
#
# SOEData retrieves data from the
# http://data.soe.com site
class SOEData
  include HTTParty
  base_uri 'data.soe.com'
end