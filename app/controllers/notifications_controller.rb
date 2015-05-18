class NotificationsController < ApplicationController

  def index
    # @notifications = Notification.unread_for_user current_user.id
  end

  def show
    notification = Notification.find params[:id]
    Notification.mark_read notification.id, current_user.id
    redirect_to notification.source
  end
end
