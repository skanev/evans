token_file = Rails.root.join('config/secret_token.txt')

if not token_file.exist? and Rails.env.production?
  raise "#{token_file} must contain a secret token"
end

secret_token = if token_file.exist?
  token_file.read.strip
else
  '7a3a2bfc22da8bb0cdb62800d63afdff107ac85c53724d5e953d19171f89270f3da861793621c29cb2fab1d627d59d89cb08a1b69db7564a542812ad12734290'
end

Trane::Application.config.secret_token = secret_token
