require 'spec_helper'

describe AnnouncementsController do
  describe "GET index" do
    it "assigns a page of news to @announcements" do
      Announcement.should_receive(:page).with('3').and_return('announcements')
      get :index, page: '3'
      assigns(:announcements).should eq 'announcements'
    end
  end

  describe "GET new" do
    log_in_as :admin

    it "denies access to non-admins" do
      current_user.stub admin?: false
      get :new
      response.should deny_access
    end

    it "assigns a new announcement to @announcement" do
      Announcement.stub new: 'announcement'
      get :new
      assigns(:announcement).should eq 'announcement'
    end
  end

  describe "POST create" do
    log_in_as :admin

    let(:announcement) { mock_model Announcement }

    before do
      Announcement.stub new: announcement
      announcement.stub :save
    end

    it "denies access to non-admins" do
      current_user.stub admin?: false
      post :create
      response.should deny_access
    end

    it "initializes an announcement with params[:announcement]" do
      Announcement.should_receive(:new).with('attributes').and_return(announcement)
      post :create, announcement: 'attributes'
    end

    it "assigns the new announcement to @announcement" do
      post :create
      assigns(:announcement).should eq announcement
    end

    it "saves the initialized announcement" do
      announcement.should_receive(:save)
      post :create
    end

    it "redirects to the show page of the created announcement on success" do
      announcement.stub save: true
      post :create
      response.should redirect_to(announcement)
    end

    it "redisplays the form on an error" do
      announcement.stub save: false
      post :create
      response.should render_template(:new)
    end
  end

  describe "GET show" do
    let(:announcement) { double }

    before do
      Announcement.stub find: announcement
    end

    it "assigns the announcement to @announcement" do
      Announcement.should_receive(:find).with('42').and_return(announcement)
      get :show, id: '42'
      assigns(:announcement).should eq announcement
    end
  end

  describe "GET edit" do
    log_in_as :admin

    it "denies access to non-admins" do
      current_user.stub admin?: false
      get :edit, id: '42'
      response.should deny_access
    end

    it "assigns the announcement to @announcement" do
      Announcement.should_receive(:find).with('42').and_return('announcement')
      get :edit, id: '42'
      assigns(:announcement).should eq 'announcement'
    end
  end

  describe "PUT update" do
    log_in_as :admin

    let(:announcement) { mock_model Announcement }

    before do
      Announcement.stub find: announcement
      announcement.stub :update_attributes
    end

    it "denies access to non-admins" do
      current_user.stub admin?: false
      put :update, id: '42'
      response.should deny_access
    end

    it "looks up the announcement by id" do
      Announcement.should_receive(:find).with('42')
      put :update, id: '42'
    end

    it "assigns the announcement to @announcement" do
      put :update, id: '42'
      assigns(:announcement).should eq announcement
    end

    it "attempts to update the announcement" do
      announcement.should_receive(:update_attributes).with('attributes')
      put :update, id: '42', announcement: 'attributes'
    end

    it "redirects to the announcement show page on success" do
      announcement.stub update_attributes: true
      put :update, id: '42'
      response.should redirect_to(announcement)
    end

    it "redisplays the form on failure" do
      announcement.stub update_attributes: false
      put :update, id: '42'
      response.should render_template(:edit)
    end
  end
end
