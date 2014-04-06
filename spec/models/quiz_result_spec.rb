require 'spec_helper'

describe QuizResult do
  it { should belong_to(:quiz) }
  it { should belong_to(:user) }

  it { should validate_presence_of :correct_answers }
  it { should validate_presence_of :points }
  it { should validate_presence_of :quiz_id }
  it { should validate_presence_of :user_id }

  it "knows the name of its user" do
    user = create :user, full_name: 'John Doe'
    result = create :quiz_result, user: user

    result.user_name.should eq 'John Doe'
  end
end
