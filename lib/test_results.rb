class TestResults
  attr_accessor :passed, :failed, :log

  def initialize(attributes = {})
    attributes.each do |key, value|
      send "#{key}=", value
    end
  end

  def passed_count
    passed.count
  end

  def failed_count
    failed.count
  end
end