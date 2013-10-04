# @author Craig Read
#
# Controller for the Drop views.
#
# json and js formatting options are available on actions
# where ajax is used via jQueryUI popups.
#
# xml formatting is provided on actions used by the ACT plug-in.
#
# index uses the DropsQuery class which will handle
# pagination, searching and rendering the drops.
class DropsController < ApplicationController
  respond_to :html
  respond_to :json, except: :invalid
  respond_to :js, only: [:destroy, :edit, :new, :show]
  respond_to :xml, only: [:show, :index]

  before_filter :set_drop, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!, :except => [:index, :show]
  before_filter :set_pagetitle
  after_filter { flash.discard if request.xhr? }

  # GET /drops
  def index
    @drops = DropsQuery.new(params).drops
    respond_with @drops
  end

  # GET /drops/invalid
  def invalid
    @drops = Drop.invalidly_assigned(params[:trash]).uniq
    respond_with @drops
  end

  # GET /drops/1
  def show
  end

  # GET /drops/new
  def new
    @drop = Drop.new
  end

  # GET /drops/1/edit
  def edit
    @drop = Drop.select(:chat).find(params[:id])
  end

  # POST /drops
  def create
    @drop = Drop.new(params[:drop])
    if @drop.save
      flash[:notice] = 'Drop was successfully created.'
      respond_with @drop
    else
      render action: :new
    end
  end

  # PUT /drops/1
  def update
    if @drop.update_attributes(params[:drop])
      flash[:notice] = 'Drop was successfully updated.'
      if request.env['HTTP_REFERER']
        redirect_to request.env['HTTP_REFERER'], :status => 303
      else
        respond_with @drop
      end
    else
      render action: :edit
    end
  end

  # DELETE /drops/1
  def destroy
    @drop.destroy
    flash[:notice] = 'Drop successfully deleted.'
    respond_with @drop
  end

  private
  def set_drop
    @drop = Drop.select(:chat).find(params[:id])
  end

  def set_pagetitle
    @pagetitle = 'Loot Drops'
  end
end