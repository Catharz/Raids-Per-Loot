require File.join(Rails.root, 'lib', 'authenticated_system.rb')

class ApplicationController < ActionController::Base
  helper :all
  protect_from_forgery

  include AuthenticatedSystem

  before_filter :get_pages_for_tabs

  def get_pages_for_tabs
    if logged_in?
      @tabs = Page.find_main
    else
      @tabs = Page.find_main_public
    end
  end
end
