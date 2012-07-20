require 'spec_helper'

describe UsersController do
  describe "GET index" do
    it "paginates all users to @user" do
      User.should_receive(:page).with('3').and_return('users')
      get :index, page: '3'
      assigns(:users).should eq 'users'
    end
  end

  describe "GET show" do
    let(:user) { double }

    before do
      User.stub find: user
    end

    it "looks up the user by id" do
      User.should_receive(:find).with('42').and_return(user)
      get :show, id: '42'
    end

    it "assigns the user to @user" do
      get :show, id: '42'
      assigns(:user).should eq user
    end
  end
end
