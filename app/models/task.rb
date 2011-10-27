class Task < ActiveRecord::Base
  validates_presence_of :name, :description

  has_many :solutions

  def closed?
    closes_at.past?
  end

  def restrictions_hash
    YAML.load(restrictions)
  end

  def restrictions_hash=(hash)
    self.restrictions = hash.to_yaml
  end
end
