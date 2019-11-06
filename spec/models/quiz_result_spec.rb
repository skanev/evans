require 'spec_helper'

describe QuizResult do
  it "knows the name of its user" do
    user = create :user, full_name: 'John Doe'
    result = create :quiz_result, user: user

    expect(result.user_name).to eq 'John Doe'
  end
end
