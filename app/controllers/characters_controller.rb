require 'delayed_job'

class CharactersController < ApplicationController
  before_filter :login_required, :except => [:index, :show, :info]
  before_filter :set_pagetitle

  def set_pagetitle
    @pagetitle = "Characters"
  end

  def option_list
    @characters = Character.order(:name)

    options = ""
    @characters.each do |character|
      options += "<option value='#{character.id}'>#{character.name}</option>"
    end
    render :text => options, :layout => false
  end

  def fetch_all_data
    @characters = Character.order(:name)
    @characters.each do |character|
      if character.archetype.nil?
        Delayed::Job.enqueue(CharacterDetailsJob.new(character.name))
      end
    end

    flash[:notice] = "Characters are being updated."
    redirect_to admin_url
  end

  def fetch_data
    @character = Character.find(params[:id])

    if @character.fetch_soe_character_details
      flash[:notice] = "Character details have been updated."
    else
      flash[:notice] = "Character details could not be updated."
    end
    redirect_to @character
  end

  # GET /characters
  # GET /characters.json
  def index
    @characters = Character.by_player(params[:player_id]).by_instance(params[:instance_id]).eager_load(:character_types)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @characters }
      format.xml { render :xml => @characters.to_xml }
    end
  end

  # GET /characters/1
  # GET /characters/1.json
  def show
    @character = Character.find(params[:id])
    @character_types = @character.character_types.order("effective_date desc")

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @character }
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
      format.json { render json: @character }
      format.xml { render :xml => @character }
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
        format.json { render json: @character, status: :created, location: @character }
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

    respond_to do |format|
      if @character.update_attributes(params[:character])
        format.html { redirect_to @character, notice: 'Character was successfully updated.' }
        format.json { head :ok }
        format.xml { head :ok }
      else
        format.html { render action: "edit" }
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
    end
  end
end
