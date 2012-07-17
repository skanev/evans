require 'spec_helper'

describe UsersController do
  describe "GET index" do
    it "paginates all users to @user" do
      User.should_receive(:page).with('3').and_return('users')
      get :index, page: '3'
      assigns(:users).should == 'users'
    end
  end

  describe "GET show" do
    let(:user) { double }

    before do
      User.stub find: user
      PointsBreakdown.stub :new
    end

    it "looks up the user by id" do
      User.should_receive(:find).with('42').and_return(user)
      get :show, id: '42'
    end

    it "assigns the user to @user" do
      get :show, id: '42'
      assigns(:user).should == user
    end

    it "assigns a point breakdown of the user to @points_breakdown" do
      PointsBreakdown.should_receive(:new).with(user).and_return('points breakdown')
      get :show, id: '42'
      assigns(:points_breakdown).should == 'points breakdown'
    end
  end
end
