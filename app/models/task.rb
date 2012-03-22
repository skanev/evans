class Task < ActiveRecord::Base
  MAX_POINTS = 6

  validates_presence_of :name, :description
  validate :restrictions_must_be_valid_yaml
  validates_numericality_of :max_points, allow_nil: true

  has_many :solutions
  has_many :comments, :through => :solutions

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

  def max_points
    self[:max_points] || MAX_POINTS
  end

  private

  def restrictions_must_be_valid_yaml
    YAML.load(restrictions)
  rescue Psych::SyntaxError
    errors.add :restrictions, :invalid
  end
end
