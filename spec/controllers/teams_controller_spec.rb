require 'spec_helper'

describe TeamsController do
  describe "GET show" do
    it "paginates all admin users to @team_members" do
      admins        = double
      sorted_admins = double

      expect(User).to receive(:admins).and_return(admins)
      expect(admins).to receive(:sorted).and_return(sorted_admins)
      expect(sorted_admins).to receive(:at_page).with('3').and_return('admins')

      get :show, page: '3'
      expect(assigns(:team_members)).to eq 'admins'
    end

    it "sets the course name and email in @course_name and @course_email" do
      Rails.configuration.stub course_name: 'cool course', course_email: 'course@example.org'

      get :show

      expect(assigns(:course_name)).to eq 'cool course'
      expect(assigns(:course_email)).to eq 'course@example.org'
    end
  end
end
