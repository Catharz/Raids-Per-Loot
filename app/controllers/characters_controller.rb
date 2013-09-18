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
  respond_to :html
  respond_to :json, :xml, :js, except: [:loot, :statistics, :option_list, :info]
  respond_to :csv, only: :index

  before_filter :set_character, only: [:show, :edit, :update, :destroy, :info, :fetch_data]
  before_filter :authenticate_user!, :except => [:index, :show, :info, :statistics, :attendance, :loot]
  before_filter :set_pagetitle

  caches_action :statistics
  caches_action :info

  def option_list
    @characters = Character.order(:name)

    options = ''
    @characters.each do |character|
      options += "<option value='#{character.id}'>#{character.name}</option>"
    end
    render :text => options, :layout => false
  end

  def attendance
    @characters = Character.order(:name)
    @characters.sort! { |a, b| b.attendance <=> a.attendance }.select! { |c| c.attendance >= 10.0 }
    respond_with @characters
  end

  def fetch_data
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
    @characters = Character.by_instance(params[:instance_id]).where(char_type: %w{m r}).
        includes(:player, :external_data, :archetype).order('characters.name')
    respond_with @characters
  end

  def statistics
    @characters = Character.joins(:archetype, :external_data)
    respond_with @characters
  end

  # GET /characters
  # GET /characters.json
  def index
    @characters = Character.by_player(params[:player_id]).
        by_instance(params[:instance_id]).by_name(params[:name]) unless respond_to? :json

    respond_to do |format|
      format.html # index.html.erb
      format.csv { render csv: @characters }
      format.json { render json: CharactersDatatable.new(view_context) }
      format.xml { render :xml => @characters.to_xml }
    end
  end

  # GET /characters/1
  # GET /characters/1.js
  # GET /characters/1.json
  # GET /characters/1.xml
  def show
    @character_types = @character.character_types.order('effective_date desc')
    respond_with @character
  end

  def info
    render :layout => false
  end

  # GET /characters/new
  # GET /characters/new.json
  def new
    @character = Character.new
    respond_with @character
  end

  # GET /characters/1/edit
  def edit
  end

  # POST /characters
  # POST /characters.json
  def create
    @character = Character.new(params[:character])

    respond_to do |format|
      if @character.save
        format.html { redirect_to @character,
                                  notice: 'Character was successfully created.'
        }
        format.json {
          render json: @character.to_json(
              methods: [:archetype_name, :main_character, :archetype_root,
                        :player_name, :first_raid_date, :last_raid_date,
                        :armour_rate, :jewellery_rate, :weapon_rate]
          ), status: :created, location: @character
        }
        format.xml { render xml: @character,
                            status: :created,
                            location: @character }
      else
        format.html { render action: 'new' }
        format.json { render json: @character.errors,
                             status: :unprocessable_entity }
        format.xml { render xml: @character.errors,
                            status: :unprocessable_entity }
      end
    end
  end

  # PUT /characters/1
  # PUT /characters/1.json
  def update
    expire_action action: :info
    expire_action action: :statistics

    respond_to do |format|
      if @character.update_attributes(params[:character])
        format.html { redirect_to @character,
                                  notice: 'Character was successfully updated.'
        }
        format.json { render :json => @character.
            to_json(methods: [:archetype_name, :archetype_root,
                              :main_character, :raid_alternate,
                              :first_raid_date, :last_raid_date,
                              :player_name, :player_raids_count,
                              :player_switches_count, :player_switch_rate,
                              :player_active]),
                             :notice => 'Character was successfully updated.' }
        format.xml { head :ok }
      else
        format.html { render action: 'edit' }
        format.json { render json: @character.errors,
                             status: :unprocessable_entity }
        format.xml { render xml: @character.errors,
                            status: :unprocessable_entity }
      end
    end
  end

  # DELETE /characters/1
  # DELETE /characters/1.json
  def destroy
    @character.destroy

    respond_to do |format|
      format.html { redirect_to characters_url }
      format.json { head :ok }
      format.xml { head :ok }
      format.js
    end
  end

  private
  def set_character
    @character = Character.find(params[:id])
  end

  def set_pagetitle
    @pagetitle = 'Characters'
  end
end