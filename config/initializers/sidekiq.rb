# TODO The namespace here needs to course-agnostic

Sidekiq.configure_server do |config|
  config.redis = {namespace: 'rbfmi-2012'}
end

Sidekiq.configure_client do |config|
  config.redis = {namespace: 'rbfmi-2012'}
end
