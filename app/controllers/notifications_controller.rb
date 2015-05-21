class NotificationsController < ApplicationController

  def index
    # @notifications = Notification.unread_for_user current_user.id
  end

  def show
    notification = Notification.find params[:id]
    notification.is_read = true
    notification.save
    redirect_to notification.source
  end
end
