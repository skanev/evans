module ModelMatchers
  RSpec::Matchers.define :have_error_on do |field, *args|
    expected_message = args.first

    match do |record|
      record.valid?
      message = record.errors[field]
      record.invalid? and message.present? and matches_message?(message, expected_message)
    end

    failure_message_for_should do |record|
      explanation =    "expected to have error on: #{field}"
      explanation += "\n             with message: #{expected_message}"
      explanation += "\n           but had errors: #{record.errors.enum_for(:each).to_a.inspect}"
      explanation
    end

    failure_message_for_should_not do |record|
      explanation =    "expected to not have error on: #{field}"
      explanation += "\n               but had errors: #{record.errors.enum_for(:each).to_a.inspect}"
      explanation
    end

    def matches_message?(actual, expected)
      return true if expected.nil?
      Array.wrap(actual).include? expected
    end
  end
end
