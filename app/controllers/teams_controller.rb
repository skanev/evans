class TeamsController < ApplicationController
  def show
    @course_name  = Rails.configuration.course_name
    @course_email = Rails.configuration.course_email
    @team_members = User.admins.page params[:page]
  end
end
