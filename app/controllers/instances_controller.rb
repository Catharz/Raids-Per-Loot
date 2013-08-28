# Controller for the Instance views.
#
# json and js formatting options are available on actions
# where ajax is used via jQueryUI popups.
#
# xml formatting is provided on actions used by the ACT plug-in.
class InstancesController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :show]
  before_filter :set_pagetitle

  def set_pagetitle
    @pagetitle = 'Raid Instances'
  end

  def option_list
    @instances = Instance.by_raid(params[:raid_id]).order(:start_time)

    options = "<option value='0'>Select Instance</option>"
    @instances.each do |instance|
      options += "<option value='#{instance.id}'>#{instance.zone_name} - #{instance.start_time}</option>"
    end
    render :text => options, :layout => false
  end

  # GET /instances
  # GET /instances.json
  def index
    @instances = Instance.by_raid(params[:raid_id]).by_zone(params[:zone_id]).by_start_time(params[:start_time]).includes(:zone)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @instances }
      format.xml  { render :xml => @instances.to_xml( :include => [:characters => [:player], :drops => [:mob, :zone, :character, :item]] ) }
    end
  end

  # GET /instances/1
  # GET /instances/1.json
  def show
    @instance = Instance.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @instance }
      format.xml  { render :xml => @instance.to_xml(:include => [:characters => [:player], :drops => [:mob, :zone, :character, :item]]) }
      format.js
    end
  end

  # GET /instances/new
  # GET /instances/new.json
  def new
    @instance = Instance.new(raid: Raid.last, start_time: Raid.last.raid_date + 20.hours)

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @instance }
      format.xml  { render :xml => @instance }
      format.js
    end
  end

  # GET /instances/1/edit
  def edit
    @instance = Instance.find(params[:id])
  end

  # POST /instances
  # POST /instances.json
  def create
    @instance = Instance.new(params[:instance])

    respond_to do |format|
      if @instance.save
        format.html { redirect_to @instance, :notice => 'Instance was successfully created.' }
        format.json { render :json => @instance.to_json(methods: [:zone_name, :kills, :players, :characters, :drops]), :status => :created, :location => @instance }
        format.xml  { render :xml => @instance, :status => :created, :location => @instance }
      else
        format.html { render :action => "new" }
        format.json { render :json => @instance.errors, :status => :unprocessable_entity }
        format.xml  { render :xml => @instance.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /instances/1
  # PUT /instances/1.json
  def update
    @instance = Instance.find(params[:id])

    respond_to do |format|
      if @instance.update_attributes(params[:instance])
        format.html { redirect_to @instance, :notice => 'Instance was successfully updated.' }
        format.json { render :json => @instance.to_json(methods: [:zone_name, :kills, :players, :characters, :drops]) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @instance.errors, :status => :unprocessable_entity }
        format.xml  { render :xml => @instance.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /instances/1
  # DELETE /instances/1.json
  def destroy
    @instance = Instance.find(params[:id])
    @instance.destroy

    respond_to do |format|
      format.html { redirect_to instances_url }
      format.json { head :ok }
      format.xml  { head :ok }
      format.js
    end
  end
end