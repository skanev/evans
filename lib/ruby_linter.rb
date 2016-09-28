require 'tempfile'

class RubyLinter
  def initialize(ruby_version, base_config, additional_restrictions)
    available_cops = RuboCop::Cop::Cop.all

    @ruby_version = ruby_version

    config    = config_for(base_config, additional_restrictions)
    @cop_team = RuboCop::Cop::Team.new(available_cops, config)
  end

  def lint(code)
    processed_source = RuboCop::ProcessedSource.new(code, @ruby_version)

    offenses = @cop_team.inspect_file(processed_source)
    offenses.map { |offense| format_offense(offense) }
  end

  private

  def config_for(base_config, additional_restrictions)
    base_config = RuboCop::Config.new(base_config, 'base_config.yml')
    base_config = RuboCop::ConfigLoader.merge_with_default(base_config, 'base_config.yml')

    config_hash = RuboCop::ConfigLoader.merge(base_config, additional_restrictions)

    RuboCop::Config.new(config_hash, 'ruby_linter_config.yml')
  end

  def format_offense(offense)
    "Line #{offense.location.line}: #{offense.message} [#{offense.cop_name}]"
  end
end
