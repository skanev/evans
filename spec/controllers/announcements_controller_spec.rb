require 'spec_helper'

describe AnnouncementsController do
  describe "GET new" do
    log_in_as :admin

    it "denies access to non-admins" do
      current_user.stub :admin? => false
      get :new
      response.should deny_access
    end

    it "assigns a new announcement to @announcement" do
      Announcement.stub :new => 'announcement'
      get :new
      assigns(:announcement).should == 'announcement'
    end
  end

  describe "POST create" do
    log_in_as :admin

    let(:announcement) { double }

    before do
      Announcement.stub :new => announcement
      announcement.stub :save
    end

    it "denies access to non-admins" do
      current_user.stub :admin? => false
      post :create
      response.should deny_access
    end

    it "initializes an announcement with params[:announcement]" do
      Announcement.should_receive(:new).with('attributes').and_return(announcement)
      post :create, :announcement => 'attributes'
    end

    it "assigns the new announcement to @announcement" do
      post :create
      assigns(:announcement).should == announcement
    end

    it "saves the initialized announcement" do
      announcement.should_receive(:save)
      post :create
    end

    it "redirects to the list of announcements on success" do
      announcement.stub :save => true
      post :create
      response.should redirect_to(announcements_path)
    end

    it "redisplays the form on an error" do
      announcement.stub :save => false
      post :create
      response.should render_template(:new)
    end
  end
end
