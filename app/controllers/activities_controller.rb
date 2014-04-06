class ActivitiesController < ApplicationController
  before_action :require_admin

  def index
    @feed = Feed.new
  end
end
