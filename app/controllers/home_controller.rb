class HomeController < ApplicationController
  def index
    @announcements  = Announcement.latest(3)
    @previous_sites = Rails.application.config.previous_instances
  end
end
