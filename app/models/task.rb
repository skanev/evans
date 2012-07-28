class Task < ActiveRecord::Base
  validates_presence_of :name, :description, :max_points
  validate :restrictions_must_be_valid_yaml
  validates_numericality_of :max_points

  has_many :solutions

  scope :checked, conditions: {checked: true}

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
