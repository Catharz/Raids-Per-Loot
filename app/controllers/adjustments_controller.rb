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
  after_filter { flash.discard if request.xhr? }

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
    if @adjustment.save
      flash[:notice] = 'Adjustment was successfully created.'
      respond_with @adjustment
    else
      render action: 'new'
    end
  end

  # PUT /adjustments/1
  # PUT /adjustments/1.json
  def update
    if @adjustment.update_attributes(params[:adjustment])
      flash[:notice] = 'Adjustment was successfully updated.'
      respond_with(@adjustment)
    else
      render action: 'edit'
    end
  end

  # DELETE /adjustments/1
  # DELETE /adjustments/1.json
  def destroy
    @adjustment.destroy
    flash[:notice] = 'Adjustment successfully deleted.'
    respond_with @adjustment
  end

  private
  def set_adjustment
    @adjustment = Adjustment.find(params[:id])
  end
end