class Poll < ActiveRecord::Base
  attr_accessible :blueprint_yaml, :name

  has_many :answers, class_name: 'PollAnswer'

  def blueprint
    YAML.load blueprint_yaml
  end

  def blueprint=(hash)
    self.blueprint_yaml = hash.to_yaml
  end
end
