class NotificationsController < ApplicationController
  def index
  end

  def show
    notification = Notification.find params[:id]
    notification.mark_as_read
    redirect_to notification.source
  end
end
