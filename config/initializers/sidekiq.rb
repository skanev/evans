Sidekiq.configure_server do |config|
  config.redis = {namespace: Rails.application.config.course_id}
end

Sidekiq.configure_client do |config|
  config.redis = {namespace: Rails.application.config.course_id}
  config.logger = nil
end
