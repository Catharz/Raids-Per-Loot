# @author Craig Read
#
# Controller for the RaidType views.
#
# json and js formatting options are available on actions
# where ajax is used via jQueryUI popups.
#
# xml formatting is provided on actions used by the ACT plug-in.
class RaidTypesController < ApplicationController
  respond_to :html
  respond_to :xml, :json, only: [:index, :show]
  before_filter :authenticate_user!, :except => [:index, :show]
  before_filter :set_pagetitle
  before_filter :set_raid_type, only: [:show, :edit, :update, :destroy]

  # GET /raid_types
  def index
    @raid_types = RaidType.by_name(params[:name])
  end

  # GET /raid_types/1
  def show
  end

  # GET /raid_types/new
  def new
    @raid_type = RaidType.new
  end

  # GET /raid_types/1/edit
  def edit
  end

  # POST /raid_types
  def create
    @raid_type = RaidType.new(params[:raid_type])

    if @raid_type.save
      flash[:notice] = 'Raid type was successfully created.'
      respond_with @raid_type
    else
      render action: 'new'
    end
  end

  # PUT /raid_types/1
  def update
    if @raid_type.update_attributes(params[:raid_type])
      flash[:notice] = 'Raid type was successfully updated.'
      respond_with @raid_type
    else
      render action: 'edit'
    end
  end

  # DELETE /raid_types/1
  def destroy
    @raid_type.destroy
    flash[:notice] = 'Raid type successfully deleted.'
    respond_with @raid_type
  end

  private

  def set_pagetitle
    @pagetitle = 'Raid Types'
  end

  def set_raid_type
    @raid_type = RaidType.find(params[:id])
  end
end
