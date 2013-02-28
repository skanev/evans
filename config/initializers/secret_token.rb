if Trane::Application.config.secret_token.nil?
  raise 'Application must define a secret token. This happens in config/site.yml for production'
end
