class CharacterTypesController < ApplicationController
  before_filter :login_required, :except => [:index, :show]
  before_filter :set_pagetitle

  def set_pagetitle
    @pagetitle = "Character Types"
  end

  # GET /character_types
  # GET /character_types.json
  def index
    @character_types = CharacterType.by_character(params[:character_id])

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /character_types/1
  # GET /character_types/1.json
  def show
    @character_type = CharacterType.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /character_types/new
  # GET /character_types/new.json
  def new
    @character_type = CharacterType.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /character_types/1/edit
  def edit
    @character_type = CharacterType.find(params[:id])
  end

  # POST /character_types
  # POST /character_types.json
  def create
    @character_type = CharacterType.new(params[:character_type])

    respond_to do |format|
      if @character_type.save
        format.html { redirect_to @character_type, notice: 'Character type was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /character_types/1
  # PUT /character_types/1.json
  def update
    @character_type = CharacterType.find(params[:id])

    respond_to do |format|
      if @character_type.update_attributes(params[:character_type])
        format.html { redirect_to @character_type, notice: 'Character type was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /character_types/1
  # DELETE /character_types/1.json
  def destroy
    @character_type = CharacterType.find(params[:id])
    @character_type.destroy

    respond_to do |format|
      format.html { redirect_to character_types_url }
    end
  end
end
