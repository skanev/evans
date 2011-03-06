require 'spec_helper'

describe AnnouncementsController do
  describe "GET new" do
    it "assigns a new announcement to @announcement" do
      Announcement.stub :new => 'announcement'
      get :new
      assigns(:announcement).should == 'announcement'
    end
  end

  describe "POST create" do
    let(:announcement) { double }

    before do
      Announcement.stub :new => announcement
      announcement.stub :save
    end

    it "initializes an announcement with params[:announcement]" do
      Announcement.should_receive(:new).with('attributes').and_return(announcement)
      post :create, :announcement => 'attributes'
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
