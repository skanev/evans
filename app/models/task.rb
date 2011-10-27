class Task < ActiveRecord::Base
  validates_presence_of :name, :description
  validate :restrictions_must_be_valid_yaml

  has_many :solutions

  def closed?
    closes_at.past?
  end

  def has_restrictions?
    self.restrictions_hash.present?
  end

  def restrictions_hash
    YAML.load(restrictions)
  end

  def restrictions_hash=(hash)
    self.restrictions = hash.to_yaml
  end

  private

  def restrictions_must_be_valid_yaml
    YAML.load(restrictions)
  rescue Psych::SyntaxError
    errors.add :restrictions, :invalid
  end
end
