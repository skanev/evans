class TeamsController < ApplicationController
  def show
    @course_name  = Rails.configuration.course_name
    @course_email = Rails.configuration.course_email
    @team_members = User.admins.sorted.at_page params[:page]
  end
end
