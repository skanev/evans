class Solution < ActiveRecord::Base
  validates_presence_of :user_id, :task_id
  validates_uniqueness_of :user_id, scope: :task_id

  belongs_to :user
  belongs_to :task

  has_many :comments, order: 'comments.created_at ASC'
  has_many :revisions, order: 'revisions.id ASC'

  delegate :max_points, to: :task

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
    revisions.last.code
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
    [points + adjustment, 0].max
  end

  def commentable_by?(user)
    return false if user.nil?
    task.closed? or user.admin? or self.user == user
  end
end
