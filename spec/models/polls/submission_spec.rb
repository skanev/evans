require 'spec_helper'

module Polls
  describe Submission do
    def build_submission(blueprint, hash = {})
      Submission.new double('poll', blueprint: blueprint), double('user'), hash
    end

    it "can construct questions from a blueprint" do
      submission = build_submission([{type: 'single-line', name: 'age', text: 'How old are you?'}])

      submission.should have(1).question
      question = submission.questions.first
      question.should be_a Question::Line
      question.name.should eq 'age'
    end

    it "can provide the values of a question" do
      submission = build_submission(
        [{type: 'single-line', name: 'age', text: 'How old are you?'}],
        {'age' => '42'}
      )

      submission.should respond_to :age
      submission.age.should eq '42'
    end

    describe "updating" do
      let(:blueprint) { [{type: 'single-line', name: 'age', text: 'Your age:'}] }
      let(:poll) { create :poll, blueprint: blueprint }
      let(:user) { create :user }

      it "creates a new PollAnswer" do
        submission = Submission.new poll, user

        expect do
          submission.update 'age' => '10'
        end.to change(PollAnswer, :count).by(1)

        answer = PollAnswer.last
        answer.answers.should eq 'age' => '10'
        answer.user.should eq user
        answer.poll.should eq poll
      end
    end
  end
end
