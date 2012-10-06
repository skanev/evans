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

    def initialize(poll, user, hash = {})
      @poll      = poll
      @user      = user
      @hash      = hash
      @questions = poll.blueprint.map { |hash| Question::Line.new hash.with_indifferent_access }
    end

    def persisted?
      false
    end

    def update(hash = {})
      @hash = @hash.merge hash

      if valid?
        poll_answer = find_or_build_poll_answer
        poll_answer.answers = @hash
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
        question.value @hash[name.to_s]
      else
        super
      end
    end

    private

    def required_answers_validations
      @questions.select(&:required?).each do |question|
        value = question.value @hash[question.name]
        errors.add question.name, :presence if value.blank?
      end
    end

    def find_or_build_poll_answer
      PollAnswer.where(poll_id: @poll.id, user_id: @user.id).first || PollAnswer.new(poll_id: @poll.id, user_id: @user.id)
    end
  end
end
