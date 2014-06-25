# @author Craig Read
#
# Controller for the CharacterType views.
#
# json and js formatting options are available on actions
# where ajax is used via jQueryUI popups.
class CharacterTypesController < ApplicationController
  respond_to :html, :json
  respond_to :js, only: [:destroy, :edit, :new, :show]
  before_filter :authenticate_user!, except: [:index, :show]
  before_filter :set_character_type, only: [:show, :edit, :update, :destroy]
  before_filter :set_pagetitle

  # GET /character_types
  # GET /character_types.json
  def index
    @character_types = CharacterType.by_character(params[:character_id])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @character_types.to_json(methods: [:character_type_name, :player_name,
                                                                    :character_name, :character_first_raid_date,
                                                                    :character_last_raid_date]) }
    end
  end

  # GET /character_types/1
  # GET /character_types/1.json
  def show
  end

  # GET /character_types/new
  # GET /character_types/new.json
  def new
    @character_type = CharacterType.new
  end

  # GET /character_types/1/edit
  def edit
  end

  # POST /character_types
  # POST /character_types.json
  def create
    @character_type = CharacterType.new(character_type_params)

    respond_to do |format|
      if @character_type.save
        format.html { redirect_to @character_type, notice: 'Character type was successfully created.' }
        format.json { render json: @character_type.to_json(methods: [:character_type_name, :player_name,
                                                                     :character_name, :character_first_raid_date,
                                                                     :character_last_raid_date]),
                             status: :created, location: @character_type  }
      else
        format.html { render action: 'new' }
        format.json { render json: @character_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /character_types/1
  # PUT /character_types/1.json
  def update
    respond_to do |format|
      if @character_type.update_attributes(character_type_params)
        format.html { redirect_to @character_type, notice: 'Character type was successfully updated.' }
        format.json { render json: @character_type.to_json(methods: [:character_type_name, :player_name,
                                                                     :character_name, :character_first_raid_date,
                                                                     :character_last_raid_date]),
                             notice: 'Character type successfully updated.' }
      else
        format.html { render action: 'edit' }
        format.json { render json: @character_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /character_types/1
  # DELETE /character_types/1.json
  def destroy
    @character_type.destroy

    respond_to do |format|
      format.html { redirect_to character_types_url }
      format.js
    end
  end

  private
  def set_character_type
    @character_type = CharacterType.find(params[:id])
  end

  def set_pagetitle
    @pagetitle = 'Character Types'
  end

  def character_type_params
    params.require(:character_type).permit(:character_id, :effective_date, :char_type,
      :normal_penalty, :progression_penalty)
  end

end
