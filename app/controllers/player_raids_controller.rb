# @author Craig Read
#
# Controller for the PlayerRaid views.
#
# json and js formatting options are available on actions
# where ajax is used via jQueryUI popups.
#
# xml formatting is provided on actions used by the ACT plug-in.
class PlayerRaidsController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :show]
  before_filter :set_pagetitle
  before_filter :set_player_raid, :only => [:show, :edit, :update, :destroy]

  # GET /player_raids
  def index
    @player_raids = PlayerRaid.by_player(params[:player_id]).by_raid(params[:raid_id])

    respond_to do |format|
      format.html # index.html.haml
      format.json { render json: @player_raids }
      format.xml { render xml: @player_raids.to_xml }
    end
  end

  # GET /player_raids/1
  def show
    respond_to do |format|
      format.html # show.html.haml
      format.json { render json: @player_raid }
      format.xml { render xml: @player_raid.to_xml }
    end
  end

  # GET /player_raids/new
  def new
    @player_raid = PlayerRaid.new

    respond_to do |format|
      format.html # new.html.haml
      format.json { render json: @player_raid }
    end
  end

  # GET /player_raids/1/edit
  def edit
  end

  # POST /player_raids
  def create
    @player_raid = PlayerRaid.new(player_raid_params)

    respond_to do |format|
      if @player_raid.save
        format.html { redirect_to @player_raid, notice: 'Player raid was successfully created.' }
        format.json { render json: @player_raid, status: :created, location: @player_raid }
      else
        format.html { render action: 'new' }
        format.json { render json: @player_raid.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /player_raids/1
  def update
    respond_to do |format|
      if @player_raid.update_attributes(player_raid_params)
        format.html { redirect_to @player_raid, notice: 'Player raid was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: 'edit' }
        format.json { render json: @player_raid.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /player_raids/1
  def destroy
    @player_raid.destroy

    respond_to do |format|
      format.html { redirect_to player_raids_url }
      format.json { head :ok }
    end
  end

  private
  def set_pagetitle
    @pagetitle = 'Player Raids'
  end

  def set_player_raid
    @player_raid = PlayerRaid.find(params[:id])
  end

  def player_raid_params
    params.require(:player_raid).permit(:player_id, :raid_id, :signed_up, :punctual, :status)
  end
end
