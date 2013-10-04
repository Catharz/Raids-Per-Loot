# @author Craig Read
#
# Controller for the LootType views.
#
# json and js formatting options are available on actions
# where ajax is used via jQueryUI popups.
#
# xml formatting is provided on actions used by the ACT plug-in.
class LootTypesController < ApplicationController
  respond_to :html, :json, :xml
  respond_to :js, only: [:destroy, :edit, :new, :show]

  before_filter :set_loot_type, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!, :except => [:index, :show]
  before_filter :set_pagetitle
  after_filter { flash.discard if request.xhr? }

  # GET /loot_types
  # GET /loot_types.xml
  def index
    @loot_types = LootType.all
  end

  # GET /loot_types/1
  # GET /loot_types/1.xml
  def show
  end

  # GET /loot_types/new
  # GET /loot_types/new.xml
  def new
    @loot_type = LootType.new
    respond_with @loot_type
  end

  # GET /loot_types/1/edit
  def edit
  end

  # POST /loot_types
  # POST /loot_types.xml
  def create
    @loot_type = LootType.new(params[:loot_type])

    if @loot_type.save
      flash[:notice] = 'Loot type was successfully created.'
      respond_with @loot_type
    else
      render action: :new
    end
  end

  # PUT /loot_types/1
  # PUT /loot_types/1.xml
  def update
    if @loot_type.update_attributes(params[:loot_type])
      flash[:notice] = 'Loot type was successfully updated.'
      respond_with @loot_type
    else
      render action: :edit
    end
  end

  # DELETE /loot_types/1
  # DELETE /loot_types/1.xml
  def destroy
    @loot_type.destroy
    respond_with @loot_type
  end

  private
  def set_loot_type
    @loot_type = LootType.find(params[:id])
  end

  def set_pagetitle
    @pagetitle = 'Loot Types'
  end
end
