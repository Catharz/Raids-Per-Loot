# @author Craig Read
#
# Controller for the Rank views.
#
# json and js formatting options are available on actions
# where ajax is used via jQueryUI popups.
#
# xml formatting is provided on actions used by the ACT plug-in.
class RanksController < ApplicationController
  respond_to :html, :json, :xml
  respond_to :js, only: [:destroy, :edit, :new, :show]

  before_filter :set_rank, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!, :except => [:index, :show]
  before_filter :set_pagetitle
  after_filter { flash.discard if request.xhr? }

  # GET /ranks
  # GET /ranks.xml
  # GET /ranks.json
  def index
    @ranks = Rank.order(:priority)
    respond_with @ranks
  end

  # GET /ranks/1
  # GET /ranks/1.xml
  # GET /ranks/1.json
  def show
    respond_with @rank
  end

  # GET /ranks/new
  # GET /ranks/new.xml
  def new
    @rank = Rank.new
    respond_with @rank
  end

  # GET /ranks/1/edit
  def edit
  end

  # POST /ranks
  # POST /ranks.xml
  # POST /ranks.json
  def create
    @rank = Rank.new(rank_params)

    if @rank.save
      flash[:notice] = 'Rank was successfully created.'
      respond_with @rank
    else
      render action: :new
    end
  end

  # PUT /ranks/1
  # PUT /ranks/1.xml
  # PUT /ranks/1.json
  def update
    if @rank.update_attributes(rank_params)
      flash[:notice] = 'Rank was successfully updated.'
      respond_with @rank
    else
      render action: :edit
    end
  end

  # DELETE /ranks/1
  # DELETE /ranks/1.xml
  # DELETE /ranks/1.json
  def destroy
    @rank.destroy
    flash[:notice] = 'Rank successfully deleted.'
    respond_with @rank
  end

  private

  def set_pagetitle
    @pagetitle = 'Player Ranks'
  end

  def set_rank
    @rank = Rank.find(params[:id])
  end

  def rank_params
    params.require(:rank).permit(:name, :priority)
  end
end
