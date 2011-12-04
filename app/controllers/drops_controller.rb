class DropsController < ApplicationController
  before_filter :login_required, :except => [:index, :show]
  before_filter :set_pagetitle

  def set_pagetitle
    @pagetitle = "Loot Drops"
  end

  # GET /drops
  # GET /drops.xml
  def index
    @drops = Drop.all
    @drops.sort! { |a, b| b.drop_time <=> a.drop_time }

    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => @drops }
    end
  end

  # GET /drops/1
  # GET /drops/1.xml
  def show
    @drop = Drop.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @drop }
    end
  end

  # GET /drops/new
  # GET /drops/new.xml
  def new
    @drop = Drop.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml { render :xml => @drop }
    end
  end

  # GET /drops/1/edit
  def edit
    @drop = Drop.find(params[:id])
  end

  # GET /drops/upload
  def upload
    zone_name = params[:zoneName]
    mob_name = params[:mobName]
    player_name = params[:playerName]
    item_name = params[:itemName]
    eq2_item_id = params[:eq2ItemId]
    drop_time = DateTime.strptime(params[:dropTime], "%d/%m/%Y %I:%M:%S%p")

    @drop = Drop.new(:zone_name => zone_name,
                     :mob_name => mob_name,
                     :player_name => player_name,
                     :item_name => item_name,
                     :eq2_item_id => eq2_item_id,
                     :drop_time => drop_time)

    respond_to do |format|
      if @drop.save
        format.html { redirect_to(@drop, :notice => 'Drop was successfully created.') }
        format.xml { render :xml => @drop, :status => :created, :location => @drop }
      else
        format.html { render :action => "new" }
        format.xml { render :xml => @drop.errors, :status => :unprocessable_entity }
      end
    end
  end

  # POST /drops
  # POST /drops.xml
  def create
    @drop = Drop.new(params[:drop])

    respond_to do |format|
      if @drop.save
        format.html { redirect_to(@drop, :notice => 'Drop was successfully created.') }
        format.xml { render :xml => @drop, :status => :created, :location => @drop }
      else
        format.html { render :action => "new" }
        format.xml { render :xml => @drop.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /drops/1
  # PUT /drops/1.xml
  def update
    @drop = Drop.find(params[:id])

    respond_to do |format|
      if @drop.update_attributes(params[:drop])
        format.html { redirect_to(@drop, :notice => 'Drop was successfully updated.') }
        format.xml { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml { render :xml => @drop.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /drops/1
  # DELETE /drops/1.xml
  def destroy
    @drop = Drop.find(params[:id])
    @drop.destroy

    respond_to do |format|
      format.html { redirect_to(drops_url) }
      format.xml { head :ok }
    end
  end

  # ASSIGN_LOOT /drops/1
  # ASSIGN_LOOT /drops/1.xml
  def assign_loot
    @drop = Drop.find(params[:id])

    respond_to do |format|
      if @drop.assign_loot
        format.html { redirect_to(@drop, :notice => 'Drop was successfully assigned.') }
        format.xml { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml { render :xml => @drop.errors, :status => :unprocessable_entity }
      end
    end
  end

  # UNASSIGN_LOOT /drops/1
  # UNASSIGN_LOOT /drops/1.xml
  def unassign_loot
    @drop = Drop.find(params[:id])

    respond_to do |format|
      if @drop.unassign_loot
        format.html { redirect_to(@drop, :notice => 'Drop was successfully unassigned.') }
        format.xml { head :ok }
      else
        format.html { redirect_to(drops_url) }
        format.xml { render :xml => @drop.errors, :status => :unprocessable_entity }
      end
    end
  end
end