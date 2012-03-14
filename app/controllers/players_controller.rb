require 'will_paginate/array'

class PlayersController < ApplicationController
  before_filter :login_required, :except => [:index, :show]
  before_filter :set_pagetitle

  helper_method :sort_column, :sort_direction

  def set_pagetitle
    @pagetitle = "Players"
  end

  # GET /players
  # GET /players.json
  def index
    @players = Player.with_name_like(params[:with_name_like]).eager_load(:archetype, :rank, :main_character)
    @players = sort_results(@players.to_a, sort_column, sort_direction.eql?("asc")).paginate(:per_page => 20, :page => params[:page])

    @archetypes = Archetype.roots

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @players }
      format.xml { render :xml => @players.to_xml }
    end
  end

  # GET /players_list
  # GET /players_list.json
  def stats
=begin
  select p.name,
         mc.name main_character,
         a.name archetype,
         r.name rank,
         count(distinct ip.instance_id) as instances,
         count(distinct rc.id) as raids,
         count(distinct d.id) as items,
         lt.name item_type
  from players p
  left outer join players mc on mc.id = p.main_character_id
  left outer join archetypes a on a.id = p.archetype_id
  left outer join ranks r on r.id = p.rank_id
  left outer join instances_players ip on ip.player_id = p.id
  left outer join instances i on i.id = ip.instance_id
  left outer join raids rc on rc.id = i.raid_id
  left outer join drops d on d.player_id = p.id
  left join items it on it.id = d.item_id
  left outer join loot_types lt on lt.id = it.loot_type_id
  where p.name like 'C%'
  group by p.name, main_character, archetype, rank, item_type;
=end
    @players = Player.with_name_like(params[:with_name_like]).of_rank(params[:rank_id]).by_instance(params[:instance_id]).eager_load({:instances => :raid}, :archetype, :rank, :main_character)

    @players = sort_results(@players.to_a, sort_column, sort_direction.eql?("asc")).paginate(:per_page => 20, :page => params[:page])

    @archetypes = Archetype.roots

    if params[:instance_id]
      @pagetitle = "Listing Participants"
    else
      @pagetitle = "Listing Players"
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @players }
      format.xml { render :xml => @players.to_xml(:include => [:instances, :drops]) }
    end
  end

# GET /players/1
# GET /players/1.json
  def show
    @player = Player.find(params[:id], :include => [:instances, :drops])

    @player_drops = @player.drops.group_by do |drop|
      if drop.item.nil? or drop.item.loot_type.nil?
        "Unknown"
      else
        drop.item.loot_type.name
      end
    end

    @player_instances = @player.instances.group_by do |instance|
      instance.start_time.to_date.beginning_of_month
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @player }
      format.xml { render :xml => @player.to_xml(:include => [:instances, :drops]) }
    end
  end

# GET /players/new
# GET /players/new.json
  def new
    @player = Player.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @player }
      format.xml { render :xml => @player }
    end
  end

# GET /players/1/edit
  def edit
    @player = Player.find(params[:id])
  end

# POST /players
# POST /players.json
  def create
    @player = Player.new(params[:player])

    respond_to do |format|
      if @player.save
        format.html { redirect_to @player, :notice => 'Player was successfully created.' }
        format.json { render :json => @player, :status => :created, :location => @player }
        format.xml { render :xml => @player, :status => :created, :location => @player }
      else
        format.html { render :action => "new" }
        format.json { render :json => @player.errors, :status => :unprocessable_entity }
        format.xml { render :xml => @player.errors, :status => :unprocessable_entity }
      end
    end
  end

# PUT /players/1
# PUT /players/1.json
  def update
    @player = Player.find(params[:id])

    respond_to do |format|
      if @player.update_attributes(params[:player])
        format.html { redirect_to @player, :notice => 'Player was successfully updated.' }
        format.json { head :ok }
        format.xml { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @player.errors, :status => :unprocessable_entity }
        format.xml { render :xml => @player.errors, :status => :unprocessable_entity }
      end
    end
  end

# DELETE /players/1
# DELETE /players/1.json
  def destroy
    @player = Player.find(params[:id])
    @player.destroy

    respond_to do |format|
      format.html { redirect_to players_url }
      format.json { head :ok }
      format.xml { head :ok }
    end
  end

  private
  def sort_results(players, sort_type, ascending)
    players.sort! do |a, b|
      case sort_type
        when "rank"
          player_a = a.rank ? a.rank.name : "Unknown"
          player_b = b.rank ? b.rank.name : "Unknown"
        when "main"
          player_a = a.main_character ? a.main_character.name : a.name
          player_b = b.main_character ? b.main_character.name : b.name
        when "archetype"
          player_a = a.archetype ? a.archetype.name : "Unknown"
          player_b = b.archetype ? b.archetype.name : "Unknown"
        when "raids"
          player_a = a.raids.count
          player_b = b.raids.count
        when "instances"
          player_a = a.instances.count
          player_b = b.instances.count
        when "armour_rate"
          player_a = a.loot_rate("Armour")
          player_b = b.loot_rate("Armour")
        when "weapon_rate"
          player_a = a.loot_rate("Weapon")
          player_b = b.loot_rate("Weapon")
        when "jewellery_rate"
          player_a = a.loot_rate("Jewellery")
          player_b = b.loot_rate("Jewellery")
        when "adornment_rate"
          player_a = a.loot_rate("Adornment")
          player_b = b.loot_rate("Adornment")
        else
          player_a = a.name
          player_b = b.name
      end
      ascending ? player_a <=> player_b : player_b <=> player_a
    end
    players.to_a
  end

  def sort_column
    params[:sort] ? params[:sort] : "name"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
end
