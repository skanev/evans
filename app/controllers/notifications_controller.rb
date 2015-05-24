class NotificationsController < ApplicationController
  def index
  end

  def show
    notification = Notification.find params[:id]
    Notification.mark_as_read notification
    redirect_to notification.source
  end
end
