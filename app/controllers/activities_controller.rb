class ActivitiesController < ApplicationController
  before_filter :require_admin

  def index
    @feed = Feed.new
  end
end
