class ZonesController < ApplicationController
  before_filter :login_required

  def add_mob
    @zone = Zone.find(params[:id])
    mob = Mob.find(params[:mob_id])

    @zone.mobs << mob unless @zone.mobs.include? mob
    respond_to do |format|
      if @zone.save
        format.html { redirect_to @zone, :notice => 'Mob was successfully added to the zone.' }
        format.json { head :ok }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @zone.errors, :status => :unprocessable_entity }
        format.xml  { render :xml => @zone.errors, :status => :unprocessable_entity }
      end
    end
  end

  # GET /zones
  # GET /zones.xml
  def index
    @zones = Zone.all

    @zones.reject! { |zone| !zone.mobs.include? Mob.find(params[:mob_id].to_i) } if params[:mob_id]

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @zones }
      format.xml  { render :xml => @zones.to_xml( :include => [:raids, :mobs]) }
    end
  end

  # GET /zones/1
  # GET /zones/1.xml
  def show
    @zone = Zone.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @zone}
      format.xml  { render :xml => @zone.to_xml( :include => [:raids, :mobs] ) }
    end
  end

  # GET /zones/new
  # GET /zones/new.xml
  def new
    @zone = Zone.new

    respond_to do |format|
      format.html # new.html.erb
      format.json  { render :json => @zone }
      format.xml  { render :xml => @zone }
    end
  end

  # GET /zones/1/edit
  def edit
    @zone = Zone.find(params[:id])
  end

  # POST /zones
  # POST /zones.xml
  def create
    @zone = Zone.new(params[:zone])

    respond_to do |format|
      if @zone.save
        format.html { redirect_to(@zone, :notice => 'Zone was successfully created.') }
        format.json  { render :json => @zone, :status => :created, :location => @zone }
        format.xml  { render :xml => @zone, :status => :created, :location => @zone }
      else
        format.html { render :action => "new" }
        format.json  { render :json => @zone.errors, :status => :unprocessable_entity }
        format.xml  { render :xml => @zone.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /zones/1
  # PUT /zones/1.xml
  def update
    @zone = Zone.find(params[:id])

    respond_to do |format|
      if @zone.update_attributes(params[:zone])
        format.html { redirect_to(@zone, :notice => 'Zone was successfully updated.') }
        format.json  { head :ok }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.json  { render :json => @zone.errors, :status => :unprocessable_entity }
        format.xml  { render :xml => @zone.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /zones/1
  # DELETE /zones/1.xml
  def destroy
    @zone = Zone.find(params[:id])
    @zone.destroy

    respond_to do |format|
      format.html { redirect_to(zones_url) }
      format.xml  { head :ok }
    end
  end
end
