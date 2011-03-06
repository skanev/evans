class AnnouncementsController < ApplicationController
  before_filter :require_admin, :only => [:new, :create]

  def index
  end

  def new
    @announcement = Announcement.new
  end

  def create
    @announcement = Announcement.new params[:announcement]

    if @announcement.save
      redirect_to announcements_path, :notice => 'Новината е създадена. Браво'
    else
      render :new
    end
  end
end
