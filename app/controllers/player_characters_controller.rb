class PlayerCharactersController < ApplicationController
  def edit
    @player_character = PlayerCharacter.new(params[:id])
  end

  def update
    @player_character = PlayerCharacter.new(params[:id])

    respond_to do |format|
      if @player_character.update_attributes(params)
        format.html { redirect_to @player_character, notice: 'Loot Stats successfully updated.' }
        format.json { render :json => @player_character.to_json(methods: [
            :player,
            :character,
            :main_character,
            :raid_alternate
        ]), :notice => 'Loot Stats successfully updated.' }
      else
        format.html { render action: 'edit' }
        format.json { render json: @player_character.errors, status: :unprocessable_entity }
      end
    end
  end
end