class StatisticsController < ApplicationController
  # GET /statistics/guild_achievements
  def guild_achievements
    @achievements = SonyDataService.new.guild_achievements
  end
end