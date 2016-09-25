class RubocopExplainer
  METRIC_DESCRIPTIONS = {
    'Metrics/MethodLength'   => 'Най-много %s реда на метод',
    'Metrics/LineLength'     => 'Най-много %s символа на ред',
    'Metrics/BlockNesting'   => 'Най-много %s нива на влагане',
    'Metrics/ParameterLists' => 'Най-много %s аргумента на метод',
    'Metrics/ClassLength'    => 'Най-много %s реда на клас',
    'Metrics/ModuleLength'   => 'Най-много %s реда на модул'
  }.freeze

  def initialize(config)
    @config = config
  end

  def descriptions
    @config.select { |cop, _| can_explain? cop }.map { |cop, _| description_for cop }
  end

  private

  def can_explain?(cop)
    cop_enabled?(cop) and description_for(cop).present?
  end

  def cop_enabled?(cop)
    @config[cop]['Enabled']
  end

  def description_for(cop)
    if @config[cop]['Description'].present?
      @config[cop]['Description']
    elsif METRIC_DESCRIPTIONS.key? cop
      METRIC_DESCRIPTIONS[cop] % @config[cop]['Max']
    end
  end
end
