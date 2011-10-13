require 'spec_helper'

describe QuizResult do
  it { should belong_to(:quiz) }
  it { should belong_to(:user) }
  it { should validate_presence_of(:correct_answers) }
  it { should validate_presence_of(:points) }

  it "knows the name of its user" do
    user = FactoryGirl.create :user, :full_name => 'John Doe'
    result = FactoryGirl.create :quiz_result, :user => user

    result.user_name.should == 'John Doe'
  end
end
