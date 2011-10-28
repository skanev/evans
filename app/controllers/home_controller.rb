class HomeController < ApplicationController
  def index
    @announcements = Announcement.latest(3)
  end
end
