# Controller for the PlayerCharacter edit view.
class PlayerCharactersController < ApplicationController
  def edit
    @player_character = PlayerCharacter.new(params[:id])
  end
end