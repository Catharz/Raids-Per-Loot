# @author Craig Read
#
# Controller for the Zone views.
#
# json and js formatting options are available on actions
# where ajax is used via jQueryUI popups.
#
# xml formatting is provided on actions used by the ACT plug-in.
class ZonesController < ApplicationController
  respond_to :html, :json, :xml
  respond_to :js, only: [:destroy, :edit, :new, :show]
  before_filter :authenticate_user!, :except => [:index, :show, :option_list]
  before_filter :set_zone, only: [:show, :edit, :update, :destroy]
  before_filter :set_pagetitle

  def option_list
    instance = params[:instance_id] ? Instance.find(params[:instance_id]) : nil
    if instance
      @zones = instance.zone ? [Zone.find(instance.zone_id)] : []
    else
      @zones = Zone.order(:name)
    end

    options = "<option value='0'>Select Zone</option>"
    @zones.each do |zone|
      options += "<option value='#{zone.id}'>#{zone.name}</option>"
    end
    render :text => options, :layout => false
  end

  # GET /zones
  # GET /zones.xml
  def index
    @zones = Zone.by_name(params[:name]).order(:name)
  end

  # GET /zones/1
  # GET /zones/1.xml
  def show
  end

  # GET /zones/new
  # GET /zones/new.xml
  def new
    @zone = Zone.new
  end

  # GET /zones/1/edit
  def edit
  end

  # POST /zones
  # POST /zones.xml
  def create
    @zone = Zone.new(params[:zone])

    if @zone.save
      flash[:notice] = 'Zone was successfully created.'
      respond_with @zone
    else
      render action: :new
    end
  end

  # PUT /zones/1
  # PUT /zones/1.xml
  def update
    if @zone.update_attributes(params[:zone])
      flash[:notice] = 'Zone was successfully updated.'
      respond_with @zone
    else
      render action: 'edit'
    end
  end

  # DELETE /zones/1
  # DELETE /zones/1.xml
  def destroy
    @zone.destroy
    flash[:notice] = 'Zone successfully deleted.'
    respond_with @zone
  end

  private
  def set_zone
    @zone = Zone.find(params[:id])
  end

  def set_pagetitle
    @pagetitle = 'Raid Zones'
  end
end
