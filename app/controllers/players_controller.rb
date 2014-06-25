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
  respond_to :html
  respond_to :csv, only: :index
  respond_to :js, only: [:destroy, :edit, :new, :show]
  respond_to :json, except: [:attendance, :option_list]
  respond_to :xml, only: [:index, :show]

  before_filter :set_player, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!, :except => [:index, :show, :attendance]
  before_filter :set_pagetitle

  after_filter { flash.discard if request.xhr? }

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
  # GET /players.xml
  def index
    @players = Player.of_rank(params[:rank_id]).by_instance(params[:instance_id]) \
      .order("players.name") \
      .includes(:rank)
  end

  def attendance
    @players = Player.order("players.name")

    respond_to do |format|
      format.html
    end
  end

  # GET /players/1
  # GET /players/1.json
  # GET /players/1.xml
  def show
  end

  # GET /players/new
  # GET /players/new.json
  def new
    @player = Player.new
  end

  # GET /players/1/edit
  def edit
  end

  # POST /players
  # POST /players.json
  def create
    @player = Player.new(player_params)

    if @player.save
      flash[:notice] = 'Player was successfully created.'
      respond_with @player
    else
      render action: :new
    end
  end

  # PUT /players/1
  # PUT /players/1.json
  def update
    if @player.update_attributes(player_params)
      flash[:notice] = 'Player was successfully updated.'
      respond_with @player
    else
      render action: 'edit'
    end
  end

  # DELETE /players/1
  # DELETE /players/1.json
  def destroy
    @player.destroy
    flash[:notice] = 'Player successfully deleted.'
    respond_with @player
  end

  private

  def set_pagetitle
    @pagetitle = 'Players'
  end

  def set_player
    @player = Player.find(params[:id])
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
