# encoding: utf-8
module ChallengesHelper
  def challenge_solution_status(solution)
    if not solution.challenge.checked?
      :unchecked
    elsif solution.correct?
      :correct
    else
      :incorrect
    end
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
