class PlayerRaidsController < ApplicationController
  before_filter :login_required, :except => [:index, :show]

  # GET /player_raids.json
  def index
    @player_raids = PlayerRaid.by_player(params[:player_id]).by_raid(params[:raid_id])

    respond_to do |format|
      format.json { render json: @player_raids }
    end
  end

  # GET /player_raids/1.json
  def show
    @player_raid = PlayerRaid.find(params[:id])

    respond_to do |format|
      format.json { render json: @player_raid }
    end
  end

  # GET /player_raids/new.json
  def new
    @player_raid = PlayerRaid.new

    respond_to do |format|
      format.json { render json: @player_raid }
    end
  end

  # GET /player_raids/1/edit
  def edit
    @player_raid = PlayerRaid.find(params[:id])
  end

  # POST /player_raids.json
  def create
    @player_raid = PlayerRaid.new(params[:player_raid])

    respond_to do |format|
      if @player_raid.save
        format.json { render json: @player_raid, status: :created, location: @player_raid }
      else
        format.json { render json: @player_raid.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /player_raids/1.json
  def update
    @player_raid = PlayerRaid.find(params[:id])

    respond_to do |format|
      if @player_raid.update_attributes(params[:player_raid])
        format.json { head :ok }
      else
        format.json { render json: @player_raid.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /player_raids/1.json
  def destroy
    @player_raid = PlayerRaid.find(params[:id])
    @player_raid.destroy

    respond_to do |format|
      format.json { head :ok }
    end
  end
end