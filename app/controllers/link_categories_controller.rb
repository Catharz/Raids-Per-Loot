# Controller for the LinkCategory views.
#
# json and js formatting options are available on actions
# where ajax is used via jQueryUI popups.
class LinkCategoriesController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :show]
  before_filter :set_pagetitle

  def set_pagetitle
    @pagetitle = 'Link Categories'
  end

  # GET /link_categories
  def index
    @link_categories = LinkCategory.all

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /link_categories/1
  # GET /link_categories/1.json
  # GET /link_categories/1.js
  def show
    @link_category = LinkCategory.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @link_category }
      format.js
    end
  end

  # GET /link_categories/new
  # GET /link_categories/new.json
  # GET /link_categories/new.js
  def new
    @link_category = LinkCategory.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @link_category }
      format.js
    end
  end

  # GET /link_categories/1/edit
  def edit
    @link_category = LinkCategory.find(params[:id])
  end

  # POST /link_categories
  # POST /link_categories.json
  def create
    @link_category = LinkCategory.new(params[:link_category])

    respond_to do |format|
      if @link_category.save
        format.html { redirect_to(@link_category, :notice => 'Link category was successfully created.') }
        format.json  { render :json => @link_category, :status => :created, :location => @link_category }
      else
        format.html { render :action => "new" }
        format.json  { render :json => @link_category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /link_categories/1
  # PUT /link_categories/1.json
  def update
    @link_category = LinkCategory.find(params[:id])

    respond_to do |format|
      if @link_category.update_attributes(params[:link_category])
        format.html { redirect_to(@link_category, :notice => 'Link category was successfully updated.') }
        format.json { render :json => @link_category, :notice => 'Link category was successfully updated.' }
      else
        format.html { render :action => "edit" }
        format.json  { render :json => @link_category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /link_categories/1
  # DELETE /link_categories/1.json
  def destroy
    @link_category = LinkCategory.find(params[:id])
    @link_category.destroy

    respond_to do |format|
      format.html { redirect_to(link_categories_url) }
      format.json  { head :ok }
      format.js
    end
  end
end
