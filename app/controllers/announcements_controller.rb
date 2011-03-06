class AnnouncementsController < ApplicationController
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
