class AdjustmentsController < ApplicationController
  before_filter :login_required, :except => [:index, :show]

  # GET /adjustments
  # GET /adjustments.json
  def index
    player_id = params[:player_id]
    character_id = params[:character_id]
    @adjustments = Adjustment.for_player(player_id).for_character(character_id)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @adjustments }
    end
  end

  # GET /adjustments/1
  # GET /adjustments/1.json
  def show
    @adjustment = Adjustment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @adjustment }
    end
  end

  # GET /adjustments/new
  # GET /adjustments/new.json
  def new
    @adjustment = Adjustment.new
    @adjustable_list = []
    @selected = ""

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @adjustment }
    end
  end

  # GET /adjustments/1/edit
  def edit
    @adjustment = Adjustment.find(params[:id])
    @adjustable_list = []

    case @adjustment.adjustable_type
      when "Character"
        adjustables = Character.order(:name)
        @selected = Character.find(@adjustment.adjustable_id).id
      when "Player"
        adjustables = Player.order(:name)
        @selected = Player.find(@adjustment.adjustable_id).id
      else
        adjustables = []
        @selected = ""
    end
    adjustables.each do |adj|
      @adjustable_list << adj.name
    end
  end

  # POST /adjustments
  # POST /adjustments.json
  def create
    @adjustment = Adjustment.new(params[:adjustment])

    respond_to do |format|
      if @adjustment.save
        format.html { redirect_to @adjustment, notice: 'Adjustment was successfully created.' }
        format.json { render json: @adjustment, status: :created, location: @adjustment }
      else
        format.html { render action: "new" }
        format.json { render json: @adjustment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /adjustments/1
  # PUT /adjustments/1.json
  def update
    @adjustment = Adjustment.find(params[:id])

    respond_to do |format|
      if @adjustment.update_attributes(params[:adjustment])
        format.html { redirect_to @adjustment, notice: 'Adjustment was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @adjustment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /adjustments/1
  # DELETE /adjustments/1.json
  def destroy
    @adjustment = Adjustment.find(params[:id])
    @adjustment.destroy

    respond_to do |format|
      format.html { redirect_to adjustments_url }
      format.json { head :ok }
    end
  end
end
