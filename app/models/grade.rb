class Grade
  attr_reader :name, :barrier

  def self.all
    Rails.configuration.grades.map do |name, barrier|
      Grade.new name, barrier.to_i
    end
  end

  def self.for(points)
    all.select do |grade|
      points >= grade.barrier
    end.max_by(&:barrier)
  end

  def self.max
    all.max_by(&:barrier)
  end

  def initialize(name, barrier)
    @name = name
    @barrier = barrier
  end
end
