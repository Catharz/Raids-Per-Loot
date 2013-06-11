require 'open-uri'

module ApplicationHelper
  def eq2_wire_item_details(eq2_item_id)
    Scraper.get("http://u.eq2wire.com/item/index/#{eq2_item_id}", ".itemd_detailwrap")
  rescue
    "Couldn't find item details for item: #{eq2_item_id}"
  end

  def menu(parent_page = nil, pages = Page.includes(:parent).order('parent_id nulls first'))
    html = '<ul>'

    pages.select { |p| parent_page.eql? p.parent}.sort{|a,b| a.position <=> b.position}.each do |page|
      html << "<li>#{page.to_url}"
      html << menu(page, pages) unless pages.select { |p| page.eql? p.parent}.empty?
      html << '</li>'
    end
    html << '</ul>'
  end
end