require 'spec_helper'

describe UsersController do
  describe "GET index" do
    it "paginates all non-admin users to @users" do
      students        = double
      sorted_students = double

      User.should_receive(:students).and_return(students)
      students.should_receive(:sorted).and_return(sorted_students)
      sorted_students.should_receive(:at_page).with('3').and_return('users')

      get :index, page: '3'
      assigns(:users).should eq 'users'
    end
  end

  describe "GET show" do
    let(:user) { double }

    before do
      User.stub find: user
      Topic.stub where: user
      Reply.stub where: user
      user.stub :group_by
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
