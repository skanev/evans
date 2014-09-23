class TaskObserver < ActiveRecord::Observer
  def after_create(task)
    TaskMailer.new_task task unless task.hidden or task.checked
  end

  def after_update(task)
    if task.hidden_changed? and not task.hidden and not task.checked
      TaskMailer.new_task task
    end
  end
end
