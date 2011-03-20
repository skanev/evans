class Solution < ActiveRecord::Base
  validates_presence_of :code, :user_id, :task_id
  validates_uniqueness_of :user_id, :scope => :task_id

  belongs_to :user
  belongs_to :task

  class << self
    def submit(user, task, code)
      solution = Solution.find_by_user_id_and_task_id(user.id, task.id) || Solution.new(:user_id => user.id, :task_id => task.id)
      solution.update_attributes :code => code
    end

    def code_for(user, task)
      Solution.find_by_user_id_and_task_id(user.id, task.id).try(:code)
    end
  end
end
