# @author Craig Read
#
# Controller for the Page Viewer.
#
# This controller manages the in-page-editing
# functionality for user-defined pages.
class ViewerController < ApplicationController
  before_filter :set_page_by_id, :except => :show
  before_filter :set_page_by_name, :only => :show

  def show
    @pagetitle = @page.title unless @page.nil?
  end

  def set_page_body
    if @page
      if @page.update_attribute(:body, view_params[:value])
        flash[:notice] = 'Page was successfully updated.'
        redirect_to view_page_url(@page.name)
      else
        render :text => @page.body
      end
    end
  end

  def get_unformatted_text
    render :layout => false, :inline => @page.body(:source)
  end

  private
  def set_page_by_id
    @page = Page.find(view_params[:id])
  end

  def set_page_by_name
    @page = Page.find_by_name(view_params[:name])
  end

  def view_params
    params.permit(:id, :name, :value)
  end
end
