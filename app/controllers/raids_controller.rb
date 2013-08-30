# @author Craig Read
#
# Controller for the Raid views.
#
# json and js formatting options are available on actions
# where ajax is used via jQueryUI popups.
#
# xml formatting is provided on actions used by the ACT plug-in.
class RaidsController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :show]
  before_filter :set_pagetitle

  def set_pagetitle
    @pagetitle = 'Raids'
  end

  # GET /raids
  # GET /raids.json
  def index
    @raids = Raid.by_date(params[:raid_date]).by_raid_type(params[:raid_type])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @raids }
      format.xml  { render :xml => @raids.to_xml( :include => [:players, :drops] ) }
    end
  end

  # GET /raids/1
  # GET /raids/1.json
  def show
    @raid = Raid.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @raid.to_json(methods: [:instances, :players, :characters, :kills, :drops]) }
      format.xml  { render :xml => @raid.to_xml(:include => [:players, :drops]) }
      format.js
    end
  end

  # GET /raids/new
  # GET /raids/new.json
  def new
    @raid = Raid.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @raid }
      format.xml  { render :xml => @raid }
      format.js
    end
  end

  # GET /raids/1/edit
  def edit
    @raid = Raid.includes([:instances, :player_raids]).find(params[:id])
  end

  # POST /raids
  # POST /raids.json
  def create
    @raid = Raid.new(params[:raid])

    respond_to do |format|
      if @raid.save
        format.html { redirect_to @raid, :notice => 'Raid was successfully created.' }
        format.json { render :json => @raid.to_json(methods: [:instances, :players, :characters, :kills, :drops]),
                             :status => :created, :location => @raid }
        format.xml  { render :xml => @raid, :status => :created, :location => @raid }
      else
        format.html { render :action => "new" }
        format.json { render :json => @raid.errors, :status => :unprocessable_entity }
        format.xml  { render :xml => @raid.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /raids/1
  # PUT /raids/1.json
  def update
    @raid = Raid.find(params[:id])

    respond_to do |format|
      if @raid.update_attributes(params[:raid])
        format.html { redirect_to @raid, :notice => 'Raid was successfully updated.' }
        format.json { render json: @raid.to_json(methods: [:instances, :players, :characters, :kills, :drops]),
                             :notice => 'Raid was successfully updated.' }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @raid.errors, :status => :unprocessable_entity }
        format.xml  { render :xml => @raid.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /raids/1
  # DELETE /raids/1.json
  def destroy
    @raid = Raid.find(params[:id])
    @raid.destroy

    respond_to do |format|
      format.html { redirect_to raids_url }
      format.json { head :ok }
      format.xml  { head :ok }
      format.js
    end
  end
end