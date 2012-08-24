class ArchetypesController < ApplicationController
  before_filter :login_required, :except => [:index, :show]

  # GET /archetypes
  # GET /archetypes.json
  def index
    @archetypes = Archetype.by_item(params[:item_id])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @archetypes }
      format.xml { render :xml => @archetypes }
    end
  end

  # GET /archetypes/1
  # GET /archetypes/1.json
  def show
    @archetype = Archetype.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @archetype }
      format.xml { render :xml => @archetype }
    end
  end

  # GET /archetypes/new
  # GET /archetypes/new.json
  def new
    @archetype = Archetype.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /archetypes/1/edit
  def edit
    @archetype = Archetype.find(params[:id])
  end

  # POST /archetypes
  # POST /archetypes.json
  def create
    @archetype = Archetype.new(params[:archetype])

    respond_to do |format|
      if @archetype.save
        format.html { redirect_to @archetype, :notice => 'Archetype was successfully created.' }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /archetypes/1
  # PUT /archetypes/1.json
  def update
    @archetype = Archetype.find(params[:id])

    respond_to do |format|
      if @archetype.update_attributes(params[:archetype])
        format.html { redirect_to @archetype, :notice => 'Archetype was successfully updated.' }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /archetypes/1
  # DELETE /archetypes/1.json
  def destroy
    @archetype = Archetype.find(params[:id])
    @archetype.destroy

    respond_to do |format|
      format.html { redirect_to archetypes_url }
    end
  end
end
