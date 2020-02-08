require 'spec_helper'

describe UsersController do
  describe "GET index" do
    it "paginates all non-admin users to @users" do
      students        = double
      sorted_students = double

      expect(User).to receive(:students).and_return(students)
      expect(students).to receive(:sorted).and_return(sorted_students)
      expect(sorted_students).to receive(:at_page).with('3').and_return('users')

      get :index, page: '3'
      expect(assigns(:users)).to eq 'users'
    end
  end

  describe "GET show" do
    let(:user) { double }

    before do
      allow(User).to receive(:find).and_return(user)
      allow(Topic).to receive(:where).and_return(user)
      allow(Reply).to receive(:where).and_return(user)
      allow(user).to receive(:group_by)
    end

    it "looks up the user by id" do
      expect(User).to receive(:find).with('42').and_return(user)
      get :show, id: '42'
    end

    it "assigns the user to @user" do
      get :show, id: '42'
      expect(assigns(:user)).to eq user
    end
  end
end
