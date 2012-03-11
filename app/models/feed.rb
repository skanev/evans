#encoding: utf-8
class Feed
  def each_activity
    activity_query.each do |row|
      yield Activity.new(row)
    end
  end

  private

  def activity_query
    activities = Comment.all.concat(Solution.all).map do |activity|
      solution = activity.kind_of?(Comment) ? activity.solution : activity
      {
        kind:         activity.kind_of?(Comment) ? 'comment' : 'solution',
        user_id:      activity.user.id,
        user_name:    activity.user.full_name,
        target_id:    solution.id,
        secondary_id: solution.task.id,
        subject:      solution.task.name,
        happened_at:  activity.kind_of?(Comment) ? activity.created_at : activity.updated_at
      }
    end

    activities.sort_by { |x| x[:happened_at] }.reverse # DESC sort (the soonest are first)
  end

  class Activity
    attr_accessor :kind, :user_id, :user_name, :target_id, :secondary_id,
                  :subject, :happened_at

    def initialize(hash)
      hash.each do |key, value|
        set key.to_sym, value
      end
    end

    def describe
      case @kind
        when :comment
          "остави коментар на"
        when :solution
          "предаде"
      end
    end

    private

    def set(name, value)
      converted = case name
        when :kind      then value.to_sym
        when :user_name then value.sub(/^(\S+) .* (\S+)$/, '\1 \2')
        when /_id$/     then value.to_i
        when /_at$/     then ActiveRecord::ConnectionAdapters::Column.string_to_time(value)
        else value
      end

      send "#{name}=", converted
    end
  end
end
