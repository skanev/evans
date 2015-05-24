class NotificationsController < ApplicationController
  def index
  end

  def show
    notification = Notification.find params[:id]
    notification.is_read = true
    notification.save
    redirect_to notification.source
  end
end
