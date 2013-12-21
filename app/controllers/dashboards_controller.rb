class DashboardsController < ApplicationController
  include ChallengesHelper
  include GradesHelper

  before_filter :require_user

  def show
    @points = current_user.points
    @points_with_project = @points + Rails.configuration.project_score

    @grade_percentage = grade_barrier(@points).to_f / max_grade_barrier
    @grade_with_project_percentage = grade_barrier(@points_with_project).to_f / max_grade_barrier

    @rank   = current_user.rank
    @total  = PointsBreakdown.count

    task_names = Task.all.map &:name
    task_points = PointsBreakdown.find(current_user.id).tasks_breakdown
    @tasks = task_names.zip task_points
    @tasks_points = @tasks.map(&:second).reject(&:nil?).reduce(0, :+)

    challenge_solutions = Hash[
      ChallengeSolution.where(user: current_user).map do |solution|
        [solution.challenge.name, solution]
      end
    ]
    @challenges = Challenge.visible.map do |challenge|
      solution_status = case
                        when challenge_solutions.has_key?(challenge.name)
                          challenge_solution_status challenge_solutions[challenge.name]
                        when challenge.checked?
                          :incorrect
                        else
                          :unchecked
                        end
      [challenge.name, solution_status]
    end
    @challenges_points = @challenges.select { |_, status| status == :correct }.size

    @starred_posts = Post.where user: current_user, starred: true
  end
end
