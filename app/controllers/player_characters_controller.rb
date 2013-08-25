class PlayerCharactersController < ApplicationController
  def edit
    @player_character = PlayerCharacter.new(params[:id])
  end
end