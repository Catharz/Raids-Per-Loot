require 'authenticated_system'

class ApplicationController < ActionController::Base
  helper :all
  protect_from_forgery

  include AuthenticatedSystem

  before_filter :get_pages_for_tabs, :get_page

  def get_page
    @page_roots ||= Page.roots.sort!{|a,b| a.position <=> b.position}
    @page = Page.find_by_name(params[:name])
    @page ||= Page.find_by_name(params[:controller]) if params[:action].eql? "index"
    @page ||= Page.first(:conditions => ["controller_name = ? AND action_name = ?", params[:controller], params[:action]])
    unless @page.nil?
      @subpages = @page.children
      @subpages.reject! {|sub_page| sub_page.admin} unless logged_in?
      @subpages.sort! {|a,b| a.position <=> b.position}
      @pagetitle = @page.title
      login_required if @page.admin?
    end
    @subpages ||= []
  end

  def get_pages_for_tabs
    @tabs = Page.roots
    @tabs.reject! { |page| page.admin } unless logged_in?
    @tabs.sort! {|a,b| a.position <=> b.position }
  end
end
