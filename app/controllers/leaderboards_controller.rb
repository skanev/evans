class LeaderboardsController < ApplicationController
  def show
    @points_breakdowns = PointsBreakdown.all
  end
end
