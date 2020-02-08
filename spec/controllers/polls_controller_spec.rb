require 'spec_helper'

describe PollsController do
  describe "GET index" do
    it "assigns all the polls" do
      allow(Poll).to receive(:all).and_return('polls')
      get :index
      expect(assigns(:polls)).to eq 'polls'
    end
  end

  describe "GET new" do
    log_in_as :admin

    let(:poll) { double }

    before do
      allow(Poll).to receive(:new).and_return(poll)
    end

    it "denies access to non-admins" do
      allow(current_user).to receive(:admin?).and_return(false)
      get :new
      expect(response).to deny_access
    end

    it "assigns a new poll" do
      get :new
      expect(assigns(:poll)).to eq poll
    end
  end

  describe "POST create" do
    log_in_as :admin

    let(:poll) { double }

    before do
      allow(Poll).to receive(:new).and_return(poll)
      allow(poll).to receive(:save)
    end

    it "constructs a new poll with the passed parameters" do
      expect(Poll).to receive(:new).with('poll-attributes')
      post :create, poll: 'poll-attributes'
    end

    it "assigns the poll" do
      post :create
      expect(assigns(:poll)).to eq poll
    end

    it "denies access to non-admins" do
      allow(current_user).to receive(:admin?).and_return(false)
      get :create
      expect(response).to deny_access
    end

    it "attemps to save the poll" do
      expect(poll).to receive :save
      post :create
    end

    it "redirects to the index on success" do
      allow(poll).to receive(:save).and_return(true)
      post :create
      expect(controller).to redirect_to polls_path
    end

    it "rerenders the form on failure" do
      allow(poll).to receive(:save).and_return(false)
      post :create
      expect(controller).to render_template :new
    end
  end

  describe "GET edit" do
    log_in_as :admin

    let(:poll) { double }

    before do
      allow(Poll).to receive(:find).and_return(poll)
    end

    it "denies access to non-admins" do
      allow(current_user).to receive(:admin?).and_return(false)
      get :edit, id: '1'
      expect(response).to deny_access
    end

    it "looks up the poll by id" do
      expect(Poll).to receive(:find).with('42')
      get :edit, id: '42'
    end

    it "assigns the poll" do
      get :edit, id: '1'
      expect(assigns(:poll)).to eq poll
    end
  end

  describe "PUT update" do
    log_in_as :admin

    let(:poll) { double }

    before do
      allow(Poll).to receive(:find).and_return(poll)
      allow(poll).to receive(:update_attributes)
    end

    it "denies access to non-admins" do
      allow(current_user).to receive(:admin?).and_return(false)
      put :update, id: '1'
      expect(response).to deny_access
    end

    it "looks up the poll by id" do
      expect(Poll).to receive(:find).with('42')
      put :update, id: '42'
    end

    it "assigns the poll" do
      put :update, id: '1'
      expect(assigns(:poll)).to eq poll
    end

    it "attempts to update the poll" do
      expect(poll).to receive(:update_attributes).with('poll-attributes')
      put :update, id: '1', poll: 'poll-attributes'
    end

    it "redirects to the polls on success" do
      allow(poll).to receive(:update_attributes).and_return(true)
      put :update, id: '1'
      expect(controller).to redirect_to polls_path
    end

    it "rerenders the form on failure" do
      allow(poll).to receive(:update_attributes).and_return(false)
      put :update, id: '1'
      expect(controller).to render_template :edit
    end
  end
end
