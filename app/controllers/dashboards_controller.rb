class DashboardsController < ApplicationController
  include ChallengesHelper

  before_filter :require_user

  def show
    @points = current_user.points
    @rank   = current_user.rank
    @total  = PointsBreakdown.count

    task_names = Task.all.map &:name
    task_points = PointsBreakdown.find(current_user.id).tasks_breakdown
    @tasks = task_names.zip task_points

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
  end
end
