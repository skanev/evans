require 'spec_helper'

describe RubyLinter do
  let(:rubocop_config) do
    YAML.load <<-YAML.strip_heredoc
      AllCops:
        DisabledByDefault: true

      Style/Semicolon:
        Enabled: true
    YAML
  end

  it 'lints using the provided base configuration' do
    violations = RubyLinter.new(2.3, rubocop_config, {}).lint('foo;bar')

    violations.should eq ['Line 1: Do not use semicolons to terminate expressions. [Style/Semicolon]']
  end

  it 'considers the configuration overrides' do
    overrides  = YAML.load <<-YAML.strip_heredoc
      Style/Semicolon:
        Enabled: false

      Metrics/LineLength:
        Enabled: true
        Max: 5
    YAML
    violations = RubyLinter.new(2.3, rubocop_config, overrides).lint('foo;bar')

    violations.should eq ['Line 1: Line is too long. [7/5] [Metrics/LineLength]']
  end
end
