class Post < ActiveRecord::Base
  TOPIC_ATTRIBUTES = %w[id title body user_id created_at updated_at]
  REPLY_ATTRIBUTES = %w[body user_id topic_id created_at updated_at]
end
