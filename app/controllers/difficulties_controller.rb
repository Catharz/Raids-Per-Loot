class DifficultiesController < ApplicationController
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
    @difficulty = Difficulty.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @difficulty }
    end
  end

  # GET /difficulties/new
  # GET /difficulties/new.json
  def new
    @difficulty = Difficulty.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @difficulty }
    end
  end

  # GET /difficulties/1/edit
  def edit
    @difficulty = Difficulty.find(params[:id])
  end

  # POST /difficulties
  # POST /difficulties.json
  def create
    @difficulty = Difficulty.new(params[:difficulty])

    respond_to do |format|
      if @difficulty.save
        format.html { redirect_to @difficulty, notice: 'Difficulty was successfully created.' }
        format.json { render json: @difficulty, status: :created, location: @difficulty }
      else
        format.html { render action: "new" }
        format.json { render json: @difficulty.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /difficulties/1
  # PUT /difficulties/1.json
  def update
    @difficulty = Difficulty.find(params[:id])

    respond_to do |format|
      if @difficulty.update_attributes(params[:difficulty])
        format.html { redirect_to @difficulty, notice: 'Difficulty was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @difficulty.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /difficulties/1
  # DELETE /difficulties/1.json
  def destroy
    @difficulty = Difficulty.find(params[:id])
    @difficulty.destroy

    respond_to do |format|
      format.html { redirect_to difficulties_url }
      format.json { head :ok }
    end
  end
end
