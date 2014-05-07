# @author Craig Read
#
# Controller for the Player views.
#
# json and js formatting options are available on actions
# where ajax is used via jQueryUI popups.
#
# xml formatting is provided on actions used by the ACT plug-in.
# csv formatting is provided for a CSV export of the player list.
class PlayersController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :show, :attendance]
  before_filter :set_pagetitle
  before_filter :set_player, :only => [:show, :edit, :update, :destroy]

  def option_list
    @players = Player.order(:name)

    options = ""
    @players.each do |player|
      options += "<option value='#{player.id}'>#{player.name}</option>"
    end
    render :text => options, :layout => false
  end

  # GET /players
  # GET /players.json
  def index
    @players = Player.of_rank(params[:rank_id]).by_instance(params[:instance_id]) \
      .order("players.name") \
      .includes(:rank)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @players }
      format.csv { render csv: @characters }
      format.xml { render :xml => @players.to_xml }
    end
  end

  def attendance
    @players = Player.order("players.name")

    respond_to do |format|
      format.html
    end
  end

# GET /players/1
# GET /players/1.json
  def show
    @player = Player.includes(:drops).find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @player.to_json(methods: [:armour_count, :jewellery_count, :weapon_count]) }
      format.xml { render :xml => @player.to_xml(:include => [:instances, :drops]) }
      format.js
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
      format.js
    end
  end

# GET /players/1/edit
  def edit
  end

# POST /players
# POST /players.json
  def create
    @player = Player.new(player_params)

    respond_to do |format|
      if @player.save
        format.html { redirect_to @player, :notice => 'Player was successfully created.' }
        format.json {
          render json: @player.to_json(
              methods: [:rank_name, :first_raid_date, :last_raid_date, :current_main, :current_raid_alternate]
          ), status: :created, location: @player }
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
    respond_to do |format|
      if @player.update_attributes(player_params)
        format.html { redirect_to @player, :notice => 'Player was successfully updated.' }
        format.json { render json: @player.to_json(
            methods: [:rank_name, :first_raid_date, :last_raid_date, :current_main, :current_raid_alternate]
        ), location: @player}
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
    @player.destroy

    respond_to do |format|
      format.html { redirect_to players_url }
      format.json { head :ok }
      format.xml { head :ok }
      format.js
    end
  end

  private
  def set_player
    @player = Player.find(params[:id])
  end

  def set_pagetitle
    @pagetitle = 'Players'
  end

  def player_params
    params.require(:player).permit(:name, :rank_id, :instances_count, :raids_count,
      :armour_rate, :jewellery_rate, :weapon_rate, :armour_count, :jewellery_count, :weapons_count,
      :adornments_count, :dislodgers_count, :mounts_count,
      :adornment_rate, :dislodger_rate, :mount_rate, :attuned_rate,
      :active, :switches_count, :switch_rate)
  end
end
