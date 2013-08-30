# @author Craig Read
#
# Controller for the Archetype views.
#
# json and js formatting options are available on actions
# where ajax is used via jQueryUI popups.
#
# xml formatting is provided on actions used by the ACT plug-in.
class ArchetypesController < ApplicationController
  before_filter :authenticate_user!, except: [:index, :show]
  before_filter :set_pagetitle

  def set_pagetitle
    @pagetitle = 'Archetypes'
  end

  # GET /archetypes
  # GET /archetypes.json
  def index
    @archetypes = Archetype.by_item(params[:item_id])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @archetypes.to_json(methods: [:parent_name, :root_name]) }
      format.xml { render xml: @archetypes }
    end
  end

  # GET /archetypes/1
  # GET /archetypes/1.json
  def show
    @archetype = Archetype.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @archetype.to_json(methods: [:parent_name, :root_name]) }
      format.xml { render xml: @archetype }
      format.js
    end
  end

  # GET /archetypes/new
  # GET /archetypes/new.json
  def new
    @archetype = Archetype.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @archetype }
      format.js
    end
  end

  # GET /archetypes/1/edit
  def edit
    @archetype = Archetype.find(params[:id])
  end

  # POST /archetypes
  # POST /archetypes.json
  def create
    @archetype = Archetype.new(params[:archetype])

    respond_to do |format|
      if @archetype.save
        format.html { redirect_to @archetype, notice: 'Archetype was successfully created.' }
        format.json { render json: @archetype.to_json(methods: [:parent_name, :root_name]),
                             status: :created, location: @archetype  }
      else
        format.html { render action: "new" }
        format.json { render json: @archetype.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /archetypes/1
  # PUT /archetypes/1.json
  def update
    @archetype = Archetype.find(params[:id])

    respond_to do |format|
      if @archetype.update_attributes(params[:archetype])
        format.html { redirect_to @archetype, notice: 'Archetype was successfully updated.' }
        format.json { render json: @archetype.to_json(methods: [:parent_name, :root_name]),
                             notice: 'Archetype was successfully updated.' }
      else
        format.html { render action: 'edit' }
        format.json { render json: @archetype.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /archetypes/1
  # DELETE /archetypes/1.json
  def destroy
    @archetype = Archetype.find(params[:id])
    @archetype.destroy

    respond_to do |format|
      format.html { redirect_to archetypes_url }
      format.js
    end
  end
end