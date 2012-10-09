module Polls
  class Submission
    include ActiveModel::Conversion
    include ActiveModel::Validations
    include ActiveModel::Naming

    attr_reader :questions

    validate :required_answers_validations

    def self.for(poll, user)
      answers = PollAnswer.where(poll_id: poll.id, user_id: user.id).first.try(:answers) || {}
      new poll, user, answers
    end

    def initialize(poll, user, answers = {})
      @poll      = poll
      @user      = user
      @answers   = answers
      @questions = poll.blueprint.map { |hash| questions_from_hash hash }
    end

    def persisted?
      false
    end

    def update(answers = {})
      @answers = @answers.merge answers

      if valid?
        poll_answer = find_or_build_poll_answer
        poll_answer.answers = @answers
        poll_answer.save!

        true
      else
        false
      end
    end

    def respond_to?(name, include_private = false)
      super or @questions.any? { |q| q.name == name.to_s }
    end

    def method_missing(name, *args, &block)
      question = @questions.detect { |q| q.name == name.to_s }

      if question
        answer_of question
      else
        super
      end
    end

    private

    def questions_from_hash(hash)
      hash = hash.with_indifferent_access

      case hash[:type]
        when 'single-line' then Question::Line.new hash
        when 'multi-line'  then Question::MultiLine.new hash
        else raise "Unknown question type: #{hash[:type]}"
      end
    end

    def required_answers_validations
      @questions.select(&:required?).each do |question|
        errors.add question.name, :presence if answer_of(question).blank?
      end
    end


    def answer_of(question)
      question.value @answers[question.name]
    end
    def find_or_build_poll_answer
      PollAnswer.where(poll_id: @poll.id, user_id: @user.id).first || PollAnswer.new(poll_id: @poll.id, user_id: @user.id)
    end
  end
end
