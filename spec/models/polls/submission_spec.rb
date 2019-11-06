require 'spec_helper'

module Polls
  describe Submission do
    def build_submission(blueprint, hash = {})
      Submission.new double('poll', blueprint: blueprint), double('user'), hash
    end

    it "constructs the questions from the poll's blueprint" do
      submission = build_submission([{type: 'single-line', name: 'age', text: 'How old are you?'}])

      expect(submission).to have(1).question
      question = submission.questions.first
      expect(question).to be_a Question::SingleLine
      expect(question.name).to eq 'age'
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

      expect(submission).to respond_to :age
      expect(submission.age).to eq '42'
    end

    it "overrides #method_missing correctly" do
      expect { build_submission([]).unexisting }.to raise_error NoMethodError
    end

    it "populates the answers if a user has already taken the poll" do
      poll = create :poll, blueprint: [{type: 'single-line', name: 'age', text: 'Your age:'}]
      user = create :user
      create :poll_answer, user: user, poll: poll, answers: {'age' => '33'}

      submission = Submission.for poll, user

      expect(submission.age).to eq '33'
    end

    describe "updating" do
      let(:blueprint) { [{type: 'single-line', name: 'age', text: 'Your age:', required: true}] }
      let(:poll) { create :poll, blueprint: blueprint }
      let(:user) { create :user }

      it "creates a new PollAnswer" do
        submission = Submission.new poll, user

        expect do
          expect(submission.update('age' => '10')).to be true
        end.to change(PollAnswer, :count).by(1)

        answer = PollAnswer.last
        expect(answer.answers).to eq 'age' => '10'
        expect(answer.user).to eq user
        expect(answer.poll).to eq poll
      end

      it "validates the presence of the required fields" do
        submission = Submission.new poll, user

        expect do
          expect(submission.update('age' => '')).to be false
        end.not_to change(PollAnswer, :count)

        expect(submission).to have_error_on(:age)
      end

      it "updates an existing PollAnswer if present" do
        poll_answer = create :poll_answer, user: user, poll: poll
        submission  = Submission.new poll, user

        submission.update 'age' => '33'

        expect(poll_answer.reload.answers).to eq 'age' => '33'
      end
    end
  end
end
