# @author Craig Read
#
# Controller for the Mob views.
#
# json and js formatting options are available on actions
# where ajax is used via jQueryUI popups.
#
# xml formatting is provided on actions used by the ACT plug-in.
class MobsController < ApplicationController
  respond_to :html, :json, :xml
  respond_to :js, only: [:destroy, :edit, :new, :show]

  before_filter :set_mob, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!, :except => [:index, :show]
  before_filter :set_pagetitle
  after_filter { flash.discard if request.xhr? }

  def option_list
    @mobs = Mob.by_zone(params[:zone_id]).order(:name)

    options = "<option value='0'>Select Mob</option>"
    @mobs.each do |mob|
      options += "<option value='#{mob.id}'>#{mob.name}</option>"
    end
    render :text => options, :layout => false
  end

  # GET /mobs
  # GET /mobs.json
  def index
    @mobs = Mob.by_zone(params[:zone_id]).by_name(params[:name]).order("mobs.name").eager_load(:drops => :instance)

    respond_with @mobs
  end

  # GET /mobs/1
  # GET /mobs/1.json
  def show
    respond_with @mob
  end

  # GET /mobs/new
  # GET /mobs/new.json
  def new
    @mob = Mob.new
    respond_with @mob
  end

  # GET /mobs/1/edit
  def edit
  end

  # POST /mobs
  # POST /mobs.json
  def create
    @mob = Mob.new(params[:mob])

    if @mob.save
      flash[:notice] = 'Mob was successfully created.'
      respond_with @mob
    else
      render action: :new
    end
  end

  # PUT /mobs/1
  # PUT /mobs/1.json
  def update
    if @mob.update_attributes(params[:mob])
      flash[:notice] = 'MOb was successfully updated.'
      respond_with @mob
    else
      render action: :edit
    end
  end

  # DELETE /mobs/1
  # DELETE /mobs/1.json
  def destroy
    @mob.destroy
    respond_with @mob
  end

  private
  def set_mob
    @mob = Mob.find(params[:id])
  end

  def set_pagetitle
    @pagetitle = 'Raid Mobs'
  end
end