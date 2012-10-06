class PollAnswer < ActiveRecord::Base
  belongs_to :poll
  belongs_to :user

  def answers
    YAML.load answers_yaml
  end

  def answers=(answers)
    self.answers_yaml = answers.to_yaml
  end
end
