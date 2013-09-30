module TasksHelper
  def show_results?(task)
    task.checked? or admin?
  end
end
