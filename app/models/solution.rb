class Solution < ActiveRecord::Base
  belongs_to :user
  belongs_to :task

  has_many :revisions, -> { order 'revisions.id ASC' }
  has_many :comments, -> { order 'comments.created_at ASC' }, through: :revisions

  validates :user_id, :task_id, presence: true
  validates :user_id, uniqueness: { scope: :task_id }

  delegate :max_points, :manually_scored?, to: :task

  class << self
    def code_for(user, task)
      self.for(user, task).try(:code)
    end

    def for(user, task)
      Solution.find_by_user_id_and_task_id(user.id, task.id)
    end

    def for_task(task_id)
      where(task_id: task_id).order('solutions.id ASC')
    end

    def calculate_points(passed, failed, max)
      return 0 if passed.zero? and failed.zero?

      (passed.quo(passed + failed) * max).round
    end
  end

  def code
    last_revision.code
  end

  def last_revision
    revisions.last
  end

  def user_name
    user.name
  end

  def task_name
    task.name
  end

  def rows
    code.split("\n").count
  end

  def total_points
    [(points || 0) + adjustment, 0].max
  end

  def commentable_by?(user)
    return false if user.nil?
    task.closed? or user.admin? or self.user == user
  end

  def visible_to?(user)
    return true if user.try(:admin?)
    return false if task.hidden?
    return true if task.closed?

    self.user == user
  end

  def update_score(score)
    self.adjustment = score[:adjustment] if score[:adjustment]
    self.points     = score[:points]     if score[:points] and task.manually_scored?
    save!
  end
end
