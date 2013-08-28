# @author Craig Read
#
# Controller for the Character views.
#
# json and js formatting options are available on actions
# where ajax is used via jQueryUI popups.
#
# xml formatting is provided on actions used by the ACT plug-in.
# csv formatting is provided for a csv export of the character list.
#
# index uses the CharactersDataTable class which will handle
# pagination, searching and rendering the drops.
class CharactersController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :show, :info, :statistics, :attendance, :loot]
  before_filter :set_pagetitle

  caches_action :statistics
  caches_action :info

  def set_pagetitle
    @pagetitle = 'Characters'
  end

  def option_list
    @characters = Character.order(:name)

    options = ""
    @characters.each do |character|
      options += "<option value='#{character.id}'>#{character.name}</option>"
    end
    render :text => options, :layout => false
  end

  def attendance
    @characters = Character.order(:name)
    @characters.sort! { |a, b| b.attendance <=> a.attendance }.select! { |c| c.attendance >= 10.0 }

    respond_to do |format|
      format.html # attendance.html.erb
      format.json { render json: @characters, methods: [:player_name, :archetype_name, :archetype_root_name, :attendance] }
    end
  end

  def fetch_data
    @character = Character.find(params[:id])

    Resque.enqueue(SonyCharacterUpdater, @character.id)
    flash[:notice] = 'Character details are being updated.'
    redirect_to @character
  end

  def update_data
    SonyCharacterUpdater.perform(params[:id])
    flash[:notice] = 'Character details are being updated.'
    redirect_to :back
  end

  # GET /characters/loot
  # GET /characters/loot.json
  def loot
    @characters = Character.by_instance(params[:instance_id]).
        where(char_type: %w{m r}).
        includes(:player, :external_data, :archetype).
        order('characters.name')
  end

  def statistics
    @characters = Character.joins(:archetype, :external_data)

    respond_to do |format|
      format.html # statistics.html.erb
      format.json { render json: @characters }
      format.xml { render :xml => @characters.to_xml }
    end
  end

  # GET /characters
  # GET /characters.json
  def index
    unless respond_to? :json
      @characters = Character.scoped
      @characters = @characters.by_player(params[:player_id]) if params[:player_id]
      @characters = @characters.by_instance(params[:instance_id]) if params[:instance_id]
      @characters = @characters.by_name(params[:name]) if params[:name]
    end

    respond_to do |format|
      format.html # index.html.erb
      format.csv { render csv: @characters }
      format.json { render json: CharactersDatatable.new(view_context) }
      format.xml { render :xml => @characters.to_xml }
    end
  end

  # GET /characters/1
  # GET /characters/1.json
  def show
    @character = Character.find(params[:id])
    @character_types = @character.character_types.order('effective_date desc')

    respond_to do |format|
      format.html # show.html.erb
      format.js # show.js.coffee
      format.json { render json: @character.to_json(methods: [:player_name,
                                                              :player_raids_count,
                                                              :player_active,
                                                              :player_switches_count,
                                                              :player_switch_rate]) }
      format.xml { render :xml => @character.to_xml(:include => [:instances, :drops]) }
    end
  end

  def info
    @character = Character.find(params[:id])

    render :layout => false
  end


  # GET /characters/new
  # GET /characters/new.json
  def new
    @character = Character.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @character.to_json(methods: [:player_name]) }
      format.xml { render :xml => @character }
      format.js
    end
  end

  # GET /characters/1/edit
  def edit
    @character = Character.find(params[:id])
  end

  # POST /characters
  # POST /characters.json
  def create
    @character = Character.new(params[:character])

    respond_to do |format|
      if @character.save
        format.html { redirect_to @character, notice: 'Character was successfully created.' }
        format.json {
          render json: @character.to_json(
              methods: [:archetype_name, :main_character, :archetype_root,
                        :player_name, :first_raid_date, :last_raid_date,
                        :armour_rate, :jewellery_rate, :weapon_rate]
          ), status: :created, location: @character
        }
        format.xml { render xml: @character, status: :created, location: @character }
      else
        format.html { render action: "new" }
        format.json { render json: @character.errors, status: :unprocessable_entity }
        format.xml { render xml: @character.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /characters/1
  # PUT /characters/1.json
  def update
    @character = Character.find(params[:id])

    expire_action action: :info
    expire_action action: :statistics

    respond_to do |format|
      if @character.update_attributes(params[:character])
        format.html { redirect_to @character, notice: 'Character was successfully updated.' }
        format.json { render :json => @character.to_json(methods: [:archetype_name, :archetype_root,
                                                                   :main_character, :raid_alternate,
                                                                   :first_raid_date, :last_raid_date,
                                                                   :player_name, :player_raids_count,
                                                                   :player_switches_count, :player_switch_rate,
                                                                   :player_active]),
                             :notice => 'Character was successfully updated.' }
        format.xml { head :ok }
      else
        format.html { render action: 'edit' }
        format.json { render json: @character.errors, status: :unprocessable_entity }
        format.xml { render xml: @character.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /characters/1
  # DELETE /characters/1.json
  def destroy
    @character = Character.find(params[:id])
    @character.destroy

    respond_to do |format|
      format.html { redirect_to characters_url }
      format.json { head :ok }
      format.xml { head :ok }
      format.js
    end
  end
end
