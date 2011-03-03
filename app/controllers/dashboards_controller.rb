class DashboardsController < ApplicationController
  before_filter :require_user

  def show
    @points = current_user.points
  end
end
