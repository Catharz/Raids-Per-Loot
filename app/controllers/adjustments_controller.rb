class AdjustmentsController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :show]
  before_filter :set_pagetitle

  def set_pagetitle
    @pagetitle = 'Adjustments'
  end

  # GET /adjustments
  # GET /adjustments.json
  def index
    @adjustments = Adjustment.for_player(params[:player_id]).for_character(params[:character_id])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @adjustments.to_json(methods: [:adjusted_name]) }
    end
  end

  # GET /adjustments/1
  # GET /adjustments/1.json
  def show
    @adjustment = Adjustment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @adjustment.to_json(methods: [:adjusted_name]) }
      format.js
    end
  end

  # GET /adjustments/new
  # GET /adjustments/new.json
  def new
    @adjustment = Adjustment.new(adjustable_id: params[:adjustable_id], adjustable_type: params[:adjustable_type])

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @adjustment }
      format.js
    end
  end

  # GET /adjustments/1/edit
  def edit
    @adjustment = Adjustment.find(params[:id])
  end

  # POST /adjustments
  # POST /adjustments.json
  def create
    @adjustment = Adjustment.new(params[:adjustment])

    respond_to do |format|
      if @adjustment.save
        format.html { redirect_to @adjustment, notice: 'Adjustment was successfully created.' }
        format.json { render json: @adjustment.to_json(methods: [:adjusted_name]), status: :created, location: @adjustment }
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
        format.json { render :json => @adjustment.to_json(methods: [:adjusted_name]), :notice => 'Adjustment was successfully updated.' }
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
      format.js
    end
  end
end
