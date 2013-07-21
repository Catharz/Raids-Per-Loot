class StatisticsController < ApplicationController
  before_filter :set_pagetitle

  def set_pagetitle
    @pagetitle = 'Statistics'
  end

  # GET /statistics/guild_achievements
  def guild_achievements
    @achievements = SonyDataService.new.guild_achievements
  end
end