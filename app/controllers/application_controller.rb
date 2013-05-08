require 'authenticated_system'

class ApplicationController < ActionController::Base
  helper :all
  protect_from_forgery

  include AuthenticatedSystem

  before_filter :get_page_details, :get_root_pages, :get_tabs

  def get_page_details
    @page, @pagetitle, @subpages = get_pages(params)
  end

  def get_pages(params)
    page = Page.find_by_name(params[:name])
    page ||= Page.find_by_name(params[:controller]) if params[:action].eql? 'index'
    page ||= Page.first(:conditions => ['controller_name = ? AND action_name = ?', params[:controller], params[:action]])
    page_title = nil
    unless page.nil?
      sub_pages = page_children(page)
      page_title = page.title
      login_required if page.admin?
    end
    sub_pages ||= []
    return page, page_title, sub_pages
  end

  def get_tabs
    @tabs = get_root_pages
    @tabs.reject! { |page| page.admin } unless logged_in?
  end

  def get_root_pages
    @page_roots = Page.order(:position).roots
  end

  def page_children(page)
    subpages = page.children
    subpages.reject! {|sub_page| sub_page.admin} unless logged_in?
    subpages.sort! {|a,b| a.position <=> b.position}
  end
end
