require 'spec_helper'

describe PollAnswer do
  it "serializes answers to and from YAML" do
    answers = {'age' => '33', 'hometown' => 'Nazareth'}
    poll_answer = create :poll_answer

    poll_answer.answers = answers
    poll_answer.answers_yaml.should eq answers.to_yaml
    poll_answer.save!

    poll_answer.reload
    poll_answer.answers.should eq answers
    poll_answer.answers_yaml.should eq answers.to_yaml
  end
end
