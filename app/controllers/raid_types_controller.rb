# @author Craig Read
#
# Controller for the RaidType views.
#
# json and js formatting options are available on actions
# where ajax is used via jQueryUI popups.
#
# xml formatting is provided on actions used by the ACT plug-in.
class RaidTypesController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :show]
  before_filter :set_raid_type, :only => [:show, :edit, :update, :destroy]
  before_filter :set_pagetitle

  # GET /raid_types
  # GET /raid_types.json
  def index
    @raid_types = RaidType.by_name(params[:name])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @raid_types }
      format.xml { render xml: @raid_types.to_xml }
    end
  end

  # GET /raid_types/1
  # GET /raid_types/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @raid_type }
      format.xml { render xml: @raid_type.to_xml }
    end
  end

  # GET /raid_types/new
  # GET /raid_types/new.json
  def new
    @raid_type = RaidType.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @raid_type }
      format.xml { render xml: @raid_type.to_xml }
    end
  end

  # GET /raid_types/1/edit
  def edit
  end

  # POST /raid_types
  # POST /raid_types.json
  def create
    @raid_type = RaidType.new(raid_type_params)

    respond_to do |format|
      if @raid_type.save
        format.html { redirect_to @raid_type, notice: 'Raid type was successfully created.' }
        format.json { render json: @raid_type, status: :created, location: @raid_type }
        format.xml { render xml: @raid_type, status: :created, location: @raid_type }
      else
        format.html { render action: "new" }
        format.json { render json: @raid_type.errors, status: :unprocessable_entity }
        format.xml { render xml: @raid_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /raid_types/1
  # PUT /raid_types/1.json
  def update
    respond_to do |format|
      if @raid_type.update_attributes(raid_type_params)
        format.html { redirect_to @raid_type, notice: 'Raid type was successfully updated.' }
        format.json { head :ok }
        format.xml { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @raid_type.errors, status: :unprocessable_entity }
        format.xml { render xml: @raid_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /raid_types/1
  # DELETE /raid_types/1.json
  def destroy
    @raid_type.destroy

    respond_to do |format|
      format.html { redirect_to raid_types_url }
      format.json { head :ok }
      format.xml { head :ok }
    end
  end

  private
  def set_pagetitle
    @pagetitle = 'Raid Types'
  end

  def set_raid_type
    @raid_type = RaidType.find(params[:id])
  end

  def raid_type_params
    params.require(:raid_type).permit(:name, :raid_counted, :raid_points, :loot_counted, :loot_cost)
  end
end
