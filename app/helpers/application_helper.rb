require 'open-uri'

# @author Craig Read
#
# ApplicationHelper provides generic
# view related helper methods
module ApplicationHelper
  def eq2_wire_item_details(eq2_item_id)
    Scraper.get("http://u.eq2wire.com/item/index/#{eq2_item_id}", ".itemd_detailwrap")
  rescue
    "Couldn't find item details for item: #{eq2_item_id}"
  end

  def menu(parent_page = nil, pages = Page.includes(:parent).order('parent_id nulls first'))
    html = '<ul>'

    pages.select { |p| parent_page.eql? p.parent}.sort{|a,b| a.position <=> b.position}.each do |page|
      html << create_page_link(page, pages)
    end
    html << '</ul>'
  end

  def show_hide_button(column_name, column_number, table_name, visible)
    link_to_function "#{column_name}",
                     'hideShowColumn("#btn_' +
                         table_name + '_col_' + column_number + '", ' +
                         table_name + ', ' + column_number + ')',
                     class: 'table-button', id: 'btn_' + table_name + '_col_' + column_number, checked: visible
  end

  private
  def create_page_link(page, pages)
    link = "<li>#{page.to_url}"
    link = link + menu(page, pages) unless pages.select { |p| page.eql? p.parent}.empty?
    link + '</li>'
  end
end
