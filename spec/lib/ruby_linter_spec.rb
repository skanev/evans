require 'spec_helper'

describe RubyLinter do
  let(:config_location) { Rails.root.join('spec/fixtures/files/rubocop-config.yml') }

  it 'lints using the provided base configuration' do
    violations = RubyLinter.new(2.3, config_location, {}).lint('foo;bar')

    expect(violations).to eq ['Line 1: Do not use semicolons to terminate expressions. [Style/Semicolon]']
  end

  it 'considers the configuration overrides' do
    overrides  = YAML.load <<-YAML.strip_heredoc
      Style/Semicolon:
        Enabled: false

      Metrics/LineLength:
        Enabled: true
        Max: 5
    YAML
    violations = RubyLinter.new(2.3, config_location, overrides).lint('foo;bar')

    expect(violations).to eq ['Line 1: Line is too long. [7/5] [Metrics/LineLength]']
  end
end
