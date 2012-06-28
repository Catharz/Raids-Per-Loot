class DropsController < ApplicationController
  before_filter :login_required, :except => [:index, :show]
  before_filter :set_pagetitle

  def set_pagetitle
    @pagetitle = "Loot Drops"
  end

  # GET /drops
  # GET /drops.xml
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => Drop.by_time(params[:drop_time]).by_instance(params[:instance_id]).by_zone(params[:zone_id]).by_mob(params[:mob_id]).by_item(params[:item_id]).by_character(params[:character_id]) }
      format.json { render json: DropsDatatable.new(view_context) }
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

  # Put /drops/upload
  def upload
    zone_name = params[:zone_name]
    mob_name = params[:mob_name]
    character_name = params[:character_name]
    item_name = params[:item_name]
    eq2_item_id = params[:eq2_item_id]
    drop_time_string = params[:drop_time_string]
    loot_type_name = params[:loot_type_name]

    zone = Zone.find_or_create_by_name(zone_name)
    mob = Mob.find_or_create_by_name_and_zone_id(mob_name, zone.id)
    character = Character.find_or_create_by_name(character_name)
    item = Item.find_or_create_by_eq2_item_id_and_name(eq2_item_id, item_name)
    loot_type = LootType.find_or_create_by_name(loot_type_name)

    drop_time = DateTime.strptime(drop_time_string, "%d/%m/%Y %I:%M:%S %p") unless drop_time_string.nil?
    drop_time ||= Date.now
    @drop = Drop.where(:zone_id => zone.id,
                       :mob_id => mob.id,
                       :character_id => character.id,
                       :item_id => item.id,
                       :loot_type_id => loot_type.id,
                       :drop_time => drop_time)
    @drop ||= Drop.new(:zone_id => zone.id,
                       :mob_id => mob.id,
                       :character_id => character.id,
                       :item_id => item.id,
                       :loot_type_id => loot_type.id,
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