class Poll < ActiveRecord::Base
  attr_accessible :blueprint_yaml, :name

  def blueprint
    YAML.load blueprint_yaml
  end

  def blueprint=(hash)
    self.blueprint_yaml = hash.to_yaml
  end
end
