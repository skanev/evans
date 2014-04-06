class PointsBreakdownsController < ApplicationController
  before_action :require_admin

  def index
    @points_breakdowns = PointsBreakdown.all
  end
end
