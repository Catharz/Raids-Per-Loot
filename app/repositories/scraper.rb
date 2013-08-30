require 'nokogiri'
require 'open-uri'

# @author Craig Read
#
# Scraper retrieves a web page and returns the HTML
# from within a specified css selector
class Scraper
  def self.get(url, node)
    Nokogiri::HTML(open(url)).css(node).to_html.html_safe
  end
end