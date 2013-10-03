require 'spec_helper'

module Polls
  describe Submission do
    def build_submission(blueprint, hash = {})
      Submission.new double('poll', blueprint: blueprint), double('user'), hash
    end

    it "constructs the questions from the poll's blueprint" do
      submission = build_submission([{type: 'single-line', name: 'age', text: 'How old are you?'}])

      submission.should have(1).question
      question = submission.questions.first
      question.should be_a Question::SingleLine
      question.name.should eq 'age'
    end

    it "raises an error if the question type does not exists" do
      expect do
        build_submission [{type: 'string'}]
      end.to raise_error 'uninitialized constant Polls::Question::String'
    end

    it "provides the answers in an ActiveModel compatible interface" do
      submission = build_submission(
        [{type: 'single-line', name: 'age', text: 'How old are you?'}],
        {'age' => '42'}
      )

      submission.should respond_to :age
      submission.age.should eq '42'
    end

    it "overrides #method_missing correctly" do
      expect { build_submission([]).unexisting }.to raise_error NoMethodError
    end

    it "populates the answers if a user has already taken the poll" do
      poll = create :poll, blueprint: [{type: 'single-line', name: 'age', text: 'Your age:'}]
      user = create :user
      create :poll_answer, user: user, poll: poll, answers: {'age' => '33'}

      submission = Submission.for poll, user

      submission.age.should eq '33'
    end

    describe "updating" do
      let(:blueprint) { [{type: 'single-line', name: 'age', text: 'Your age:', required: true}] }
      let(:poll) { create :poll, blueprint: blueprint }
      let(:user) { create :user }

      it "creates a new PollAnswer" do
        submission = Submission.new poll, user

        expect do
          submission.update('age' => '10').should be_true
        end.to change(PollAnswer, :count).by(1)

        answer = PollAnswer.last
        answer.answers.should eq 'age' => '10'
        answer.user.should eq user
        answer.poll.should eq poll
      end

      it "validates the presence of the required fields" do
        submission = Submission.new poll, user

        expect do
          submission.update('age' => '').should be_false
        end.not_to change(PollAnswer, :count)

        submission.should have_error_on(:age)
      end

      it "updates an existing PollAnswer if present" do
        poll_answer = create :poll_answer, user: user, poll: poll
        submission  = Submission.new poll, user

        submission.update 'age' => '33'

        poll_answer.reload.answers.should eq 'age' => '33'
      end
    end
  end
end
