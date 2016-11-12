class TaskDecorator < Draper::Decorator
  delegate_all

  def table_row_class
    if task.hidden?
      'hidden'
    elsif task.closed?
      ''
    elsif task.closes_at < 2.days.from_now
      'warning'
    else
      'active'
    end
  end
end
