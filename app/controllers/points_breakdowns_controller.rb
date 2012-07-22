class PointsBreakdownsController < ApplicationController
  before_filter :require_admin

  def index
    @points_breakdowns = PointsBreakdown.all
  end
end
