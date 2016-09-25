require 'tempfile'

class RubyLinter
  def initialize(ruby_version, base_config_location, additional_restrictions)
    available_cops = RuboCop::Cop::Cop.all

    @ruby_version = ruby_version

    config    = config_for(base_config_location, additional_restrictions)
    @cop_team = RuboCop::Cop::Team.new(available_cops, config)
  end

  def lint(code)
    processed_source = RuboCop::ProcessedSource.new(code, @ruby_version)

    offenses = @cop_team.inspect_file(processed_source)
    offenses.map { |offense| format_offense(offense) }
  end

  private

  def load_configuration_from(base_config_location)
    yml_configuration = <<-YAML.strip_heredoc
      inherit_from: #{base_config_location}

      AllCops:
        DisabledByDefault: true
    YAML

    Tempfile.open ['rubocop-config', '.yml'] do |config_file|
      File.write(config_file.path, yml_configuration)

      defaults = RuboCop::ConfigLoader.load_file(config_file.path)

      RuboCop::ConfigLoader.merge_with_default(defaults, config_file.path)
    end
  end

  def config_for(base_config_location, additional_restrictions)
    base_config = load_configuration_from(base_config_location)
    config_hash = RuboCop::ConfigLoader.merge(base_config, additional_restrictions)

    RuboCop::Config.new(config_hash, 'task_restrictions')
  end

  def format_offense(offense)
    "Line #{offense.location.line}: #{offense.message} [#{offense.cop_name}]"
  end
end
