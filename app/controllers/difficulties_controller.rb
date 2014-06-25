# @author Craig Read
#
# Controller for the Difficulty views.
#
# json and js formatting options are available on actions
# where ajax is used via jQueryUI popups.
class DifficultiesController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :show]
  before_filter :set_difficulty, only: [:show, :edit, :update, :destroy]
  before_filter :set_pagetitle

  # GET /difficulties
  # GET /difficulties.json
  def index
    @difficulties = Difficulty.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @difficulties }
    end
  end

  # GET /difficulties/1
  # GET /difficulties/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @difficulty }
      format.js
    end
  end

  # GET /difficulties/new
  # GET /difficulties/new.json
  def new
    @difficulty = Difficulty.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @difficulty }
      format.js
    end
  end

  # GET /difficulties/1/edit
  def edit
  end

  # POST /difficulties
  # POST /difficulties.json
  def create
    @difficulty = Difficulty.new(difficulty_params)

    respond_to do |format|
      if @difficulty.save
        format.html { redirect_to @difficulty, notice: 'Difficulty was successfully created.' }
        format.json { render json: @difficulty.to_json, status: :created, location: @difficulty }
      else
        format.html { render action: "new" }
        format.json { render json: @difficulty.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /difficulties/1
  # PUT /difficulties/1.json
  def update
    respond_to do |format|
      if @difficulty.update_attributes(difficulty_params)
        format.html { redirect_to @difficulty, notice: 'Difficulty was successfully updated.' }
        format.json { render json: @difficulty }
      else
        format.html { render action: "edit" }
        format.json { render json: @difficulty.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /difficulties/1
  # DELETE /difficulties/1.json
  def destroy
    @difficulty.destroy

    respond_to do |format|
      format.html { redirect_to difficulties_url }
      format.json { head :ok }
      format.js
    end
  end

  private
  def set_pagetitle
    @pagetitle = 'Difficulties'
  end

  def set_difficulty
    @difficulty = Difficulty.find(params[:id])
  end

  def difficulty_params
    params.require(:difficulty).permit(:name, :rating)
  end
end
