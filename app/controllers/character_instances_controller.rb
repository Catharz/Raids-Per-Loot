# @author Craig Read
#
# Controller for the CharacterInstance views.
class CharacterInstancesController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :show]
  before_filter :set_pagetitle

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
      format.xml { render json: @character_instance.to_xml }
    end
  end

  # GET /character_instances/new.json
  def new
    @character_instance = CharacterInstance.new

    respond_to do |format|
      format.json { render json: @character_instance }
    end
  end

  # POST /character_instances.json
  def create
    @character_instance = CharacterInstance.new(character_instance_params)

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
      if @character_instance.update_attributes(character_instance_params)
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

  private

  def set_pagetitle
    @pagetitle = 'Instances'
  end

  def character_instance_params
    params.require(:character_instance).permit(:character_id, :instance_id)
  end
end
