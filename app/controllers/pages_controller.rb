# @author Craig Read
#
# Controller for the Page views.
#
# json and js formatting options are available on actions
# where ajax is used via jQueryUI popups.
class PagesController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :show]
  before_filter :set_pagetitle
  before_filter :set_page, only: [:show, :edit, :update, :destroy]

  # GET /pages
  # GET /pages.json
  def index
    @pages = Page.order(:id)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @pages }
    end
  end

  # GET /pages/1
  # GET /pages/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @page }
    end
  end

  # GET /pages/new
  # GET /pages/new.json
  def new
    @page = Page.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @page }
    end
  end

  # GET /pages/1/edit
  def edit
  end

  # POST /pages
  # POST /pages.json
  def create
    @page = Page.new(page_params)

    respond_to do |format|
      if @page.save
        format.html { redirect_to @page, :notice => 'Page was successfully created.' }
        format.json { render :json => @page, :status => :created, :location => @page }
      else
        format.html { render :action => "new" }
        format.json { render :json => @page.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /pages/1
  # PUT /pages/1.json
  def update
    respond_to do |format|
      if @page.update_attributes(page_params)
        format.html { redirect_to @page, :notice => 'Page was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @page.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /pages/1
  # DELETE /pages/1.json
  def destroy
    @page.destroy

    respond_to do |format|
      format.html { redirect_to pages_url, :notice => "Page was successfully deleted." }
      format.json { head :ok }
    end
  end

  private
  def set_page
    @page = Page.find(params[:id])
  end

  def set_pagetitle
    @pagetitle = 'Pages'
  end

  def page_params
    params.require(:page).permit(:name, :title, :body, :admin, :parent_id, :navlabel,
      :position, :redirect, :action_name, :controller_name, :pages_count)
  end
end
