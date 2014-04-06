class Topic < Post
  has_many :replies, -> { order 'created_at ASC' }

  attr_accessible :title, :body

  validates :title, presence: true

  def topic_title
    title
  end

  def replies_on_page(page)
    replies.paginate page: page, per_page: Reply.per_page
  end

  def pages_of_replies
    if replies.count == 0
      1
    else
      (replies.count - 1) / Reply.per_page + 1
    end
  end

  def last_reply_id
    replies.last.try(:id)
  end

  def last_poster
    User.find(last_poster_id)
  end

  def last_post_at
    ActiveSupport::TimeZone['UTC'].parse(last_post_at_before_type_cast).in_time_zone
  end

  class << self
    def boards_page(page)
      select(<<-END).order('last_post_at DESC').paginate(page: page, per_page: per_page)
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
