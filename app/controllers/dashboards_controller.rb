class DashboardsController < ApplicationController
  before_filter :require_user

  def show
    @dashboard = Dashboard.for current_user
    @grade_progress = grade_progress_for @dashboard.grade
    @grade_with_project_progress = grade_progress_for @dashboard.grade_with_project
    @grades = Grade.all.map do |grade|
      [grade.name, grade_progress_for(grade)]
    end
    @points_from_tasks = @dashboard.tasks.map(&:second).reject(&:nil?).reduce(0, :+)
    @points_from_challenges = @dashboard.challenges.select { |_, status| status == :correct }.size
  end

  private

  def grade_progress_for(grade)
    grade.barrier.to_f / Grade.max.barrier
  end
end
