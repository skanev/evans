require 'spec_helper'

describe TeamsController do
  describe "GET show" do
    it "paginates all admin users to @team_members" do
      admins        = double
      sorted_admins = double

      User.should_receive(:admins).and_return(admins)
      admins.should_receive(:sorted).and_return(sorted_admins)
      sorted_admins.should_receive(:at_page).with('3').and_return('admins')

      get :show, page: '3'
      assigns(:team_members).should eq 'admins'
    end

    it "sets the course name and email in @course_name and @course_email" do
      Rails.configuration.stub course_name: 'cool course', course_email: 'course@example.org'

      get :show

      assigns(:course_name).should eq 'cool course'
      assigns(:course_email).should eq 'course@example.org'
    end
  end
end
