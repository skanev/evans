class AnnouncementsController < ApplicationController
  before_action :require_admin, except: :index

  def index
    @announcements = Announcement.page params[:page]

    respond_to do |format|
      format.html
      format.rss { response.headers['Content-Type'] = 'application/rss+xml; charset=utf-8' }
    end
  end

  def new
    @announcement = Announcement.new
  end

  def create
    @announcement = Announcement.new params[:announcement]

    if @announcement.save
      redirect_to announcements_path, notice: 'Новината е създадена. Браво'
    else
      render :new
    end
  end

  def edit
    @announcement = Announcement.find params[:id]
  end

  def update
    @announcement = Announcement.find params[:id]

    if @announcement.update_attributes params[:announcement]
      redirect_to announcements_path, notice: 'Новината е обновена. Честито'
    else
      render :edit
    end
  end
end
