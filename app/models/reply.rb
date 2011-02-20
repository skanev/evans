class Reply < ActiveRecord::Base
  belongs_to :topic
  belongs_to :user

  validates_presence_of :body, :user_id, :topic_id

  after_create :update_topic_last_poster

  attr_accessible :body

  private

  def update_topic_last_poster
    topic.last_poster_id = user_id
    topic.last_post_at = created_at
    topic.save!
  end
end
