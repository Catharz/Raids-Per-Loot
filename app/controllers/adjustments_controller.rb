# @author Craig Read
#
# Controller for the Adjustment views.
#
# json and js formatting options are available on actions
# where ajax is used via jQueryUI popups.
class AdjustmentsController < ApplicationController
  respond_to :html, :json, :js

  before_filter :set_adjustment, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!, :except => [:index, :show]
  before_filter :set_pagetitle

  def set_pagetitle
    @pagetitle = 'Adjustments'
  end

  # GET /adjustments
  # GET /adjustments.json
  def index
    @adjustments = Adjustment.for_player(params[:player_id]).for_character(params[:character_id])
  end

  # GET /adjustments/1
  # GET /adjustments/1.json
  def show
    respond_with @adjustment
  end

  # GET /adjustments/new
  # GET /adjustments/new.json
  def new
    @adjustment = Adjustment.new(adjustable_id: params[:adjustable_id], adjustable_type: params[:adjustable_type])
  end

  # GET /adjustments/1/edit
  def edit
  end

  # POST /adjustments
  # POST /adjustments.json
  def create
    @adjustment = Adjustment.new(params[:adjustment])

    respond_to do |format|
      if @adjustment.save
        format.html { redirect_to @adjustment, notice: 'Adjustment was successfully created.' }
        format.json { render json: @adjustment.to_json(methods: [:adjusted_name]),
                             status: :created, location: @adjustment }
      else
        format.html { render action: "new" }
        format.json { render json: @adjustment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /adjustments/1
  # PUT /adjustments/1.json
  def update
    respond_to do |format|
      if @adjustment.update_attributes(params[:adjustment])
        format.html { redirect_to @adjustment, notice: 'Adjustment was successfully updated.' }
        format.json { render :json => @adjustment.to_json(methods: [:adjusted_name]),
                             :notice => 'Adjustment was successfully updated.' }
      else
        format.html { render action: "edit" }
        format.json { render json: @adjustment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /adjustments/1
  # DELETE /adjustments/1.json
  def destroy
    @adjustment.destroy

    respond_to do |format|
      format.html { redirect_to adjustments_url }
      format.json { head :ok }
      format.js
    end
  end

  private
  def set_adjustment
    @adjustment = Adjustment.find(params[:id])
  end
end