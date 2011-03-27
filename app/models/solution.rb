class Solution < ActiveRecord::Base
  validates_presence_of :code, :user_id, :task_id
  validates_uniqueness_of :user_id, :scope => :task_id

  belongs_to :user
  belongs_to :task

  def rows
    code.split("\n").count
  end

  class << self
    def submit(user, task, code)
      return false if task.closed?
      solution = self.for(user, task) || Solution.new(:user_id => user.id, :task_id => task.id)
      solution.update_attributes :code => code
    end

    def code_for(user, task)
      self.for(user, task).try(:code)
    end

    def for(user, task)
      Solution.find_by_user_id_and_task_id(user.id, task.id)
    end

    def for_task(task_id)
      where(:task_id => task_id)
    end
  end
end
