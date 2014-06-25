# @author Craig Read
#
# Controller for the Link views.
#
# json and js formatting options are available on actions
# where ajax is used via jQueryUI popups.
#
# xml formatting is provided on actions used by the ACT plug-in.
class LinksController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :show, :list]
  before_filter :set_pagetitle

  def set_pagetitle
    @pagetitle = 'Links'
  end

  # GET /links
  def index
    @links = Link.all

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def list
    @link_categories = LinkCategory.order(:description).includes(:links)
  end

  # GET /links/1
  # GET /links/1.json
  # GET /links/1.js
  def show
    @link = Link.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @link }
      format.js
    end
  end

  # GET /links/new
  # GET /links/new.json
  # GET /links/new.js
  def new
    @link = Link.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @link }
      format.js
    end
  end

  # GET /links/1/edit
  def edit
    @link = Link.find(params[:id])
  end

  # POST /links
  # POST /links.json
  def create
    @link = Link.new(link_params)

    respond_to do |format|
      if @link.save
        format.html { redirect_to(@link, :notice => 'Link was successfully created.') }
        format.json { render :json => @link, :status => :created, :location => @link }
      else
        format.html { render :action => "new" }
        format.json { render :json => @link.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /links/1
  # PUT /links/1.json
  def update
    @link = Link.find(params[:id])

    respond_to do |format|
      if @link.update_attributes(link_params)
        format.html { redirect_to(@link, :notice => 'Link was successfully updated.') }
        format.json { render :json => @link, :notice => 'Link was successfully updated.' }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @link.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /links/1
  # DELETE /links/1.json
  # DELETE /links/1.js
  def destroy
    @link = Link.find(params[:id])
    @link.destroy

    respond_to do |format|
      format.html { redirect_to(links_url) }
      format.json { head :ok }
      format.js
    end
  end

  private
  def link_params
    params.require(:link).permit(:url, :title, :description)
  end
end
