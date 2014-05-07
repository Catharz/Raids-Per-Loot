# @author Craig Read
#
# Controller for the Guild Statistics view.
#
# This uses the SonyDataService to retrieve the
# guild achievements from data.soe.com
class StatisticsController < ApplicationController
  before_filter :set_pagetitle

  # GET /statistics/guild_achievements
  def guild_achievements
    @achievements = SonyDataService.new.guild_achievements
  end

  private

  def set_pagetitle
    @pagetitle = 'Statistics'
  end
end
