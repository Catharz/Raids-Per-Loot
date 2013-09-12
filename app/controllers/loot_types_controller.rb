# @author Craig Read
#
# Controller for the LootType views.
#
# json and js formatting options are available on actions
# where ajax is used via jQueryUI popups.
#
# xml formatting is provided on actions used by the ACT plug-in.
class LootTypesController < ApplicationController
  respond_to :html, :json, :js, :xml

  before_filter :set_loot_type, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!, :except => [:index, :show]
  before_filter :set_pagetitle

  def set_pagetitle
    @pagetitle = 'Loot Types'
  end

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

    respond_to do |format|
      if @loot_type.save
        format.html { redirect_to(@loot_type, :notice => 'Loot type was successfully created.') }
        format.xml  { render :xml => @loot_type, :status => :created, :location => @loot_type }
        format.json { render :json => @loot_type.as_json(methods: [:default_loot_method_name]),
                             :status => :created, :location => @loot_type }
      else
        format.html { render :action => 'new' }
        format.xml  { render :xml => @loot_type.errors, :status => :unprocessable_entity }
        format.json { render :json => @loot_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /loot_types/1
  # PUT /loot_types/1.xml
  def update
    respond_to do |format|
      if @loot_type.update_attributes(params[:loot_type])
        format.html { redirect_to(@loot_type, :notice => 'Loot type was successfully updated.') }
        format.xml  { head :ok }
        format.json { render :json => @loot_type.as_json(methods: [:default_loot_method_name]),
                             :notice => 'Loot type was successfully updated.' }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @loot_type.errors, :status => :unprocessable_entity }
        format.json { render :json => @loot_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /loot_types/1
  # DELETE /loot_types/1.xml
  def destroy
    @loot_type.destroy

    respond_to do |format|
      format.html { redirect_to(loot_types_url) }
      format.xml  { head :ok }
      format.json { head :ok }
      format.js
    end
  end

  private
  def set_loot_type
    @loot_type = LootType.find(params[:id])
  end
end
