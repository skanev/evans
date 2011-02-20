class Reply < ActiveRecord::Base
  belongs_to :topic
  belongs_to :user

  validates_presence_of :body, :user_id, :topic_id

  attr_accessible :body
end
