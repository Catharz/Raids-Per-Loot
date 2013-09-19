# @author Craig Read
#
# Controller for the Archetype views.
#
# json and js formatting options are available on actions
# where ajax is used via jQueryUI popups.
#
# xml formatting is provided on actions used by the ACT plug-in.
class ArchetypesController < ApplicationController
  respond_to :html, :json
  respond_to :js, only: [:destroy, :edit, :new, :show]
  respond_to :xml, only: [:show, :index]

  before_filter :set_archetype, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!, except: [:index, :show]
  before_filter :set_pagetitle
  after_filter { flash.discard if request.xhr? }

  # GET /archetypes
  # GET /archetypes.json
  def index
    @archetypes = Archetype.by_item(params[:item_id])
  end

  # GET /archetypes/1
  # GET /archetypes/1.json
  def show
  end

  # GET /archetypes/new
  # GET /archetypes/new.json
  def new
    @archetype = Archetype.new
  end

  # GET /archetypes/1/edit
  def edit
  end

  # POST /archetypes
  # POST /archetypes.json
  def create
    @archetype = Archetype.new(params[:archetype])
    if @archetype.save
      flash[:notice] = 'Archetype was successfully created.'
      respond_with @archetype
    else
      render action: 'new'
    end
  end

  # PUT /archetypes/1
  # PUT /archetypes/1.json
  def update
    if @archetype.update_attributes(params[:archetype])
      flash[:notice] = 'Archetype was successfully updated.'
      respond_with @archetype
    else
      render action: 'edit'
    end
  end

  # DELETE /archetypes/1
  # DELETE /archetypes/1.json
  def destroy
    @archetype.destroy
    flash[:notice] = 'Archetype successfully deleted.'
    respond_with @archetype
  end

  private
  def set_archetype
    @archetype = Archetype.find(params[:id])
  end

  def set_pagetitle
    @pagetitle = 'Archetypes'
  end
end