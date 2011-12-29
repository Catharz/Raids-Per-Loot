class LootTypesController < ApplicationController
  # GET /loot_types
  # GET /loot_types.xml
  def index
    @loot_types = LootType.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @loot_types.to_xml( :include => [:items, :drops] ) }
    end
  end

  # GET /loot_types/1
  # GET /loot_types/1.xml
  def show
    @loot_type = LootType.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @loot_type.to_xml( :include => [:items, :drops] ) }
    end
  end

  # GET /loot_types/new
  # GET /loot_types/new.xml
  def new
    @loot_type = LootType.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @loot_type }
    end
  end

  # GET /loot_types/1/edit
  def edit
    @loot_type = LootType.find(params[:id])
  end

  # POST /loot_types
  # POST /loot_types.xml
  def create
    @loot_type = LootType.new(params[:loot_type])

    respond_to do |format|
      if @loot_type.save
        format.html { redirect_to(@loot_type, :notice => 'Loot type was successfully created.') }
        format.xml  { render :xml => @loot_type, :status => :created, :location => @loot_type }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @loot_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /loot_types/1
  # PUT /loot_types/1.xml
  def update
    @loot_type = LootType.find(params[:id])

    respond_to do |format|
      if @loot_type.update_attributes(params[:loot_type])
        format.html { redirect_to(@loot_type, :notice => 'Loot type was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @loot_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /loot_types/1
  # DELETE /loot_types/1.xml
  def destroy
    @loot_type = LootType.find(params[:id])
    @loot_type.destroy

    respond_to do |format|
      format.html { redirect_to(loot_types_url) }
      format.xml  { head :ok }
    end
  end
end
