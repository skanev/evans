require 'spec_helper'

describe ProfilesController do
  log_in_as :student

  describe "GET edit" do
    it "assigns my user to @user" do
      get :edit
      assigns(:user).should eq current_user
    end

    it "denies access if unauthenticated" do
      controller.stub current_user: nil
      get :edit
      response.should deny_access
    end
  end

  describe "PUT update" do
    before do
      controller.stub :sign_in
      current_user.stub :update_attributes
    end

    it "assigns my user to @user" do
      put :update
      assigns(:user).should eq current_user
    end

    it "updates my user" do
      current_user.should_receive(:update_attributes).with('attributes')
      put :update, user: 'attributes'
    end

    it "redirects to the dashboard on success" do
      current_user.stub update_attributes: true
      put :update
      response.should redirect_to(dashboard_path)
    end

    it "refreshes the credentials in session on success" do
      controller.should_receive(:sign_in).with(current_user, bypass: true)
      current_user.stub update_attributes: true
      put :update
    end

    it "redisplays the form on failure" do
      current_user.stub update_attributes: false
      put :update
      response.should render_template(:edit)
    end
  end
end
