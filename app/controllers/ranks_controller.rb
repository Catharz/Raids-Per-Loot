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


  def set_pagetitle
    @pagetitle = 'Player Ranks'
  end

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

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @rank }
      format.json { render json: @rank }
      format.js
    end
  end

  # GET /ranks/1/edit
  def edit
  end

  # POST /ranks
  # POST /ranks.xml
  # POST /ranks.json
  def create
    @rank = Rank.new(params[:rank])

    respond_to do |format|
      if @rank.save
        format.html { redirect_to(@rank, :notice => 'Rank was successfully created.') }
        format.xml  { render :xml => @rank, :status => :created, :location => @rank }
        format.json { render json: @rank.to_json, status: :created, location: @rank }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @rank.errors, :status => :unprocessable_entity }
        format.json { render json: @rank.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /ranks/1
  # PUT /ranks/1.xml
  # PUT /ranks/1.json
  def update
    respond_to do |format|
      if @rank.update_attributes(params[:rank])
        format.html { redirect_to(@rank, :notice => 'Rank was successfully updated.') }
        format.xml  { head :ok }
        format.json { render :json => @rank.to_json, :notice => 'Rank was successfully updated.' }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @rank.errors, :status => :unprocessable_entity }
        format.json { render json: @rank.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ranks/1
  # DELETE /ranks/1.xml
  # DELETE /ranks/1.json
  def destroy
    @rank.destroy

    respond_to do |format|
      format.html { redirect_to(ranks_url) }
      format.xml  { head :ok }
      format.json { head :ok }
      format.js
    end
  end

  private
  def set_rank
    @rank = Rank.find(params[:id])
  end
end
