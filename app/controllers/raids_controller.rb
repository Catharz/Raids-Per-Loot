# @author Craig Read
#
# Controller for the Raid views.
#
# json and js formatting options are available on actions
# where ajax is used via jQueryUI popups.
#
# xml formatting is provided on actions used by the ACT plug-in.
class RaidsController < ApplicationController
  respond_to :html, :json, :xml
  respond_to :js, only: [:destroy, :edit, :new, :show]

  before_filter :set_raid, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!, :except => [:index, :show]
  before_filter :set_pagetitle
  after_filter { flash.discard if request.xhr? }

  # GET /raids
  # GET /raids.json
  def index
    @raids = Raid.by_date(params[:raid_date]).by_raid_type(params[:raid_type])
    respond_with @raids
  end

  # GET /raids/1
  # GET /raids/1.json
  def show
  end

  # GET /raids/new
  # GET /raids/new.json
  def new
    @raid = Raid.new
  end

  # GET /raids/1/edit
  def edit
  end

  # POST /raids
  # POST /raids.json
  def create
    @raid = Raid.new(params[:raid])

    if @raid.save
      flash[:notice] = 'Raid was successfully created.'
      respond_with @raid
    else
      render action: :new
    end
  end

  # PUT /raids/1
  # PUT /raids/1.json
  def update
    if @raid.update_attributes(params[:raid])
      flash[:notice] = 'Raid was successfully updated.'
      respond_with @raid
    else
      render action: :edit
    end
  end

  # DELETE /raids/1
  # DELETE /raids/1.json
  def destroy
    @raid.destroy
    respond_with @raid
  end

  private
  def set_raid
    @raid = Raid.find(params[:id])
  end

  def set_pagetitle
    @pagetitle = 'Raids'
  end
end