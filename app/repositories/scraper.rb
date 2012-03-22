require 'nokogiri'
require 'open-uri'

class Scraper
  def self.get(url, node)
    Nokogiri::HTML(open(url)).css(node).to_html.html_safe
  end
end