class Post < ActiveRecord::Base
  def last_poster
    User.find(last_poster_id)
  end

  def last_post_at
    ActiveSupport::TimeZone['UTC'].parse(last_post_at_before_type_cast).in_time_zone
  end

  class << self
    def topic_page(page)
      Topic.with_last_post_data.paginate(:page => page, :per_page => Topic.per_page)
    end

    def with_last_post_data
      select(<<-END).order('last_post_at DESC')
        posts.id,
        posts.title,
        #{attribute_of_last_reply('created_at')} AS last_post_at,
        #{attribute_of_last_reply('user_id')} AS last_poster_id,
        (SELECT COUNT(id) FROM posts AS replies WHERE replies.topic_id = posts.id) AS replies_count
      END
    end

    private

    def attribute_of_last_reply(column)
      <<-END
        COALESCE(
          (
            SELECT replies.#{column}
              FROM posts AS replies
              WHERE replies.topic_id = posts.id
              ORDER BY replies.created_at DESC
              LIMIT 1
          ),
          posts.#{column}
        )
      END
    end
  end
end
