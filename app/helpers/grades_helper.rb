module GradesHelper
  def grades
    Rails.configuration.grades.map do |grade, barrier|
      [grade, barrier.to_i]
    end
  end

  def max_grade_barrier
    grades.max_by { |_, barrier| barrier }.second
  end

  def grade(points)
    grades.select do |grade, barrier|
      points >= barrier
    end.max_by do |grade, barrier|
      barrier
    end
  end

  def grade_barrier(points)
    grade(points).second
  end

  def grade_name(points)
    grade(points).first
  end
end
