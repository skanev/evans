require 'spec_helper'

describe UsersController do
  describe "GET index" do
    it "paginates all users to @user" do
      User.should_receive(:paginate).with(:page => '3').and_return('users')
      get :index, :page => '3'
      assigns(:users).should == 'users'
    end
  end

  describe "GET show" do
    it "assigns the user to @user" do
      User.should_receive(:find).with(42).and_return('user')
      get :show, :id => 42
      assigns(:user).should == 'user'
    end
  end
end
