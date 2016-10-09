Before do
  mock_rubocop_config = Rails.root.join('spec/fixtures/files/rubocop-config.yml')
  Rails.application.config.rubocop_config_location = mock_rubocop_config
end
