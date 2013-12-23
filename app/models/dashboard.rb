class Dashboard
  include ChallengesHelper

  attr_reader :points

  def self.for(user)
    Dashboard.new user
  end

  def initialize(user)
    @user = user
    @points_breakdown = PointsBreakdown.find user.id
  end

  def points
    @user.points
  end

  def points_with_project
    points + Rails.configuration.project_score
  end

  def grade
    Grade.for points
  end

  def grade_with_project
    Grade.for points_with_project
  end

  def rank
    @user.rank
  end

  def total_ranks
    PointsBreakdown.count
  end

  def tasks
    task_names = Task.all.map(&:name)
    task_points = @points_breakdown.tasks_breakdown
    task_names.zip task_points
  end

  def challenges
    solutions = challenge_solutions
    Challenge.visible.map do |challenge|
      solution_status = case
                        when solutions.has_key?(challenge.name)
                          challenge_solution_status solutions[challenge.name]
                        when challenge.checked?
                          :incorrect
                        else
                          :unchecked
                        end
      [challenge.name, solution_status]
    end
  end

  def stars
    Post.where user: @user, starred: true
  end

  def vouchers
    @points_breakdown.vouchers
  end

  def attributions
    @user.attributions
  end

  private

  def admin?
    @user.admin?
  end

  def challenge_solutions
    Hash[
      ChallengeSolution.where(user: @user).map do |solution|
        [solution.challenge.name, solution]
      end
    ]
  end
end
