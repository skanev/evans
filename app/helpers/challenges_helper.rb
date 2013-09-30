module ChallengesHelper
  STATUSES = {
    unchecked: 'Непроверено',
    correct: 'Коректно',
    incorrect: 'Некоректно',
  }

  def challenge_solution_status(solution)
    return :unchecked if not admin? and not solution.challenge.checked?
    return :unchecked if admin? and solution.log.blank?

    solution.correct? ? :correct : :incorrect
  end

  def challenge_solution_status_text(solution)
    STATUSES.fetch challenge_solution_status(solution)
  end
end
