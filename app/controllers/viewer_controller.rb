class ViewerController < ApplicationController
  in_place_edit_for :page, :body

  def show
    @page = Page.find_by_name(params[:name])
    if @page
      @subpages = @page.subpages
      @pagetitle = @page.title
      login_required if @page.admin?
    end
  end

  def set_page_body
    @page = Page.find(params[:id])
    if @page
      if @page.update_attribute(:body, params[:value])
        flash[:notice] = 'Page was successfully updated.'
        redirect_to view_page_path(@page.name)
      else
        render :text => @page.body
      end
    end
  end

  def get_unformatted_text
    @page = Page.find(params[:id])
    render :text => @page.body(:source) unless @page.nil?
  end
end
