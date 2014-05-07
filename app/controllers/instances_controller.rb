# @author Craig Read
#
# Controller for the Instance views.
#
# json and js formatting options are available on actions
# where ajax is used via jQueryUI popups.
#
# xml formatting is provided on actions used by the ACT plug-in.
class InstancesController < ApplicationController
  respond_to :html, :json, :xml
  respond_to :js, only: [:show, :new, :destroy]
  before_filter :set_pagetitle
  before_filter :set_instance, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!, except: [:index, :show]
  after_filter { flash.discard if request.xhr? }

  def option_list
    @instances = Instance.by_raid(params[:raid_id]).order(:start_time)

    options = "<option value='0'>Select Instance</option>"
    @instances.each do |instance|
      options += "<option value='#{instance.id}'>#{instance.zone_name} - #{instance.start_time}</option>"
    end
    render text: options, layout: false
  end

  # GET /instances
  # GET /instances.json
  def index
    @instances = Instance.by_raid(params[:raid_id]).by_zone(params[:zone_id]).by_start_time(params[:start_time]).
        includes(:zone)
    respond_with @instances
  end

  # GET /instances/1
  # GET /instances/1.json
  def show
    respond_with @instance
  end

  # GET /instances/new
  # GET /instances/new.json
  def new
    # defaulting any new instance to being associated with the last raid and starting at 8pm
    @instance = Instance.new(raid: Raid.last, start_time: Raid.last.raid_date + 20.hours)
    respond_with @instance
  end

  # GET /instances/1/edit
  def edit
  end

  # POST /instances
  # POST /instances.json
  def create
    @instance = Instance.new(instance_params)

    if @instance.save
      flash[:notice] = 'Instance was successfully created.'
      respond_with @instance
    else
      render action: :new
    end
  end

  # PUT /instances/1
  # PUT /instances/1.json
  def update
    if @instance.update_attributes(instance_params)
      flash[:notice] = 'Instance was successfully updated.'
      respond_with @instance
    else
      render action: :edit
    end
  end

  # DELETE /instances/1
  # DELETE /instances/1.json
  def destroy
    @instance.destroy
    flash[:notice] = 'Instance successfully deleted.'
    respond_with @instance
  end

  private
  def set_pagetitle
    @pagetitle = 'Raid Instances'
  end

  def set_instance
    @instance = Instance.find(params[:id])
  end

  def instance_params
    params.require(:instance).permit(:raid_id, :zone_id, :start_time)
  end
end
