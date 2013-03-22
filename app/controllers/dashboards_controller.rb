class DashboardsController < ApplicationController
  before_filter :require_user

  def show
    @points = current_user.points
    @rank   = current_user.rank
    @total  = PointsBreakdown.count
  end
end
