class ChallengeDecorator < Draper::Decorator
  delegate_all

  def table_row_class
    if challenge.closed?
      ''
    elsif challenge.closes_at < 1.day.from_now
      'warning'
    else
      'active'
    end
  end
end
