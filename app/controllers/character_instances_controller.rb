class CharacterInstancesController < ApplicationController
  before_filter :login_required, :except => [:index, :show]

  # GET /character_instances.json
  def index
    @character_instances = CharacterInstance.by_character(params[:character_id]).by_instance(params[:instance_id])

    respond_to do |format|
      format.json { render json: @character_instances }
      format.xml { render xml: @character_instances.to_xml }
    end
  end

  # GET /character_instances/1.json
  def show
    @character_instance = CharacterInstance.find(params[:id])

    respond_to do |format|
      format.json { render json: @character_instance }
    end
  end

  # GET /character_instances/new.json
  def new
    @character_instance = CharacterInstance.new

    respond_to do |format|
      format.json { render json: @character_instance }
    end
  end

  # GET /character_instances/1/edit
  def edit
    @character_instance = CharacterInstance.find(params[:id])
  end

  # POST /character_instances.json
  def create
    @character_instance = CharacterInstance.new(params[:character_instance])

    respond_to do |format|
      if @character_instance.save
        format.json { render json: @character_instance, status: :created, location: @character_instance }
      else
        format.json { render json: @character_instance.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /character_instances/1.json
  def update
    @character_instance = CharacterInstance.find(params[:id])

    respond_to do |format|
      if @character_instance.update_attributes(params[:character_instance])
        format.json { head :ok }
      else
        format.json { render json: @character_instance.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /character_instances/1.json
  def destroy
    @character_instance = CharacterInstance.find(params[:id])
    @character_instance.destroy

    respond_to do |format|
      format.json { head :ok }
    end
  end

end