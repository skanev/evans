class Task < ActiveRecord::Base
  validates :name, :description, presence: true
  validates :max_points, numericality: true, presence: true
  validate :restrictions_must_be_valid_yaml

  has_many :solutions

  scope :checked, -> { where checked: true }
  scope :in_chronological_order, -> { order 'created_at ASC' }

  class << self
    def visible
      in_chronological_order.where(hidden: false)
    end

    def next_unscored_solution(task_id)
      Solution.where(task_id: task_id, points: nil).order('id ASC').first
    end
  end

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

  def has_visible_solutions?
    closed? and not hidden?
  end

  private

  def restrictions_must_be_valid_yaml
    YAML.load(restrictions)
  rescue Psych::SyntaxError
    errors.add :restrictions, :invalid
  end
end
