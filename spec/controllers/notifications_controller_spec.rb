require 'spec_helper'

describe NotificationsController do
  describe "GET index" do
    it "assigns unread user notifications to @notifications" do
      controller.stub_chain(:current_user).and_return(:user)
      Notification.should_receive(:unread_for_user).with(:user).and_return('notifications')
      get :index
      assigns(:notifications).should eq 'notifications'
    end
  end

  describe "GET show" do
    notification = FactoryGirl.build_stubbed(:notification)

    it "marks notification as read and redirects to its source" do
      Notification.should_receive(:find).with('3').and_return(notification)
      get :show, id: '3'
      response.should redirect_to notification.source
    end
  end
end
