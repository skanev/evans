# encoding: utf-8
module ChallengesHelper
  def challenge_solution_status(solution)
    return :unchecked if not admin? and not solution.challenge.checked?
    return :unchecked if admin? and solution.log.blank?

    solution.correct? ? :correct : :incorrect
  end

  def challenge_solution_status_text(solution)
    status = challenge_solution_status solution

    case status
      when :unchecked then 'Непроверено'
      when :correct   then 'Коректно'
      when :incorrect then 'Некоректно'
      else raise "Unknown solution status: #{status}"
    end
  end
end
