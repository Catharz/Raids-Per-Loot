module ApplicationHelper
  def eq2_wire_item_details(eq2_item_id)
    Scraper.get("http://u.eq2wire.com/item/index/#{eq2_item_id}", ".itemd_detailwrap")
  rescue
    "<b>Couldn't find item details for item: #{eq2_item_id}</b>"
  end

  def build_tree(pages)
    html = "<ul>"
    pages.sort{|a,b| a.position <=> b.position}.each do |page|
      url = page.redirect ? "#{page.controller_name}/#{page.action_name}" : page.name
      html = "#{html}<li><a href='/#{url}'>#{page.navlabel}</a>"

      html = page.children.empty? ? "#{html}</li>" : "#{html}#{build_tree(page.children)}</li>"
    end
    "#{html}</ul>"
  end
end