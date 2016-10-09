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
    config_path = if url? base_config_location
                    RuboCop::RemoteConfig.new(base_config_location, Dir.tmpdir).file
                  else
                    base_config_location
                  end

    config_hash = YAML.load(File.read(config_path))
    config = RuboCop::Config.new(config_hash, config_path)

    RuboCop::ConfigLoader.merge_with_default(config, config_path)
  end

  def config_for(base_config_location, additional_restrictions)
    base_config = load_configuration_from(base_config_location)
    config_hash = RuboCop::ConfigLoader.merge(base_config, additional_restrictions)

    RuboCop::Config.new(config_hash, 'task_restrictions.yml')
  end

  def format_offense(offense)
    "Line #{offense.location.line}: #{offense.message} [#{offense.cop_name}]"
  end

  def url?(path_or_url)
    path_or_url.to_s.start_with? 'http'
  end
end
