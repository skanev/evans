class ActivitiesController < ApplicationController
  before_filter :require_admin

  def index
    @feed = Feed.new

    respond_to do |format|
      format.html
      format.rss { response.headers['Content-Type'] = 'application/rss+xml; charset=utf-8' }
    end
  end
end
