class LinkCategoriesController < ApplicationController
  before_filter :login_required
  before_filter :set_pagetitle

  def set_pagetitle
    @pagetitle = "Link Categories"
  end


  # GET /link_categories
  # GET /link_categories.xml
  def index
    @link_categories = LinkCategory.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @link_categories }
    end
  end

  # GET /link_categories/1
  # GET /link_categories/1.xml
  def show
    @link_category = LinkCategory.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @link_category }
    end
  end

  # GET /link_categories/new
  # GET /link_categories/new.xml
  def new
    @link_category = LinkCategory.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @link_category }
    end
  end

  # GET /link_categories/1/edit
  def edit
    @link_category = LinkCategory.find(params[:id])
  end

  # POST /link_categories
  # POST /link_categories.xml
  def create
    @link_category = LinkCategory.new(params[:link_category])

    respond_to do |format|
      if @link_category.save
        format.html { redirect_to(@link_category, :notice => 'Link category was successfully created.') }
        format.xml  { render :xml => @link_category, :status => :created, :location => @link_category }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @link_category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /link_categories/1
  # PUT /link_categories/1.xml
  def update
    @link_category = LinkCategory.find(params[:id])

    respond_to do |format|
      if @link_category.update_attributes(params[:link_category])
        format.html { redirect_to(@link_category, :notice => 'Link category was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @link_category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /link_categories/1
  # DELETE /link_categories/1.xml
  def destroy
    @link_category = LinkCategory.find(params[:id])
    @link_category.destroy

    respond_to do |format|
      format.html { redirect_to(link_categories_url) }
      format.xml  { head :ok }
    end
  end
end
