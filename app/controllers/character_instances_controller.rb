# @author Craig Read
#
# Controller for the CharacterInstance views.
class CharacterInstancesController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :show]
  before_filter :set_character_instance, only: [:show, :edit, :update, :destroy]
  respond_to :json, :xml

  # GET /character_instances.json
  def index
    @character_instances = CharacterInstance.by_character(params[:character_id]).by_instance(params[:instance_id])
  end

  # GET /character_instances/1.json
  def show
  end

  def edit
  end

  # GET /character_instances/new.json
  def new
    @character_instance = CharacterInstance.new
  end

  # POST /character_instances.json
  def create
    @character_instance = CharacterInstance.new(params[:character_instance])

    if @character_instance.save
      flash[:notice] = 'Character instance was successfully created.'
      respond_with @character_instance, status: :created
    else
      render action: 'new'
    end
  end

  # PUT /character_instances/1.json
  def update
    if @character_instance.update_attributes(params[:character_instance])
      flash[:notice] = 'Character Instance was successfully updated.'
      respond_with @character_instance
    else
      render action: 'edit', status: :unprocessable_entity
    end
  end

  # DELETE /character_instances/1.json
  def destroy
    @character_instance.destroy
    flash[:notice] = 'Character Instance successfully deleted.'
    respond_with @character_instance
  end

  private
  def set_character_instance
    @character_instance = CharacterInstance.find(params[:id])
  end
end
