require 'spec_helper'

describe RubocopExplainer do
  it 'can describe all relevant metrics without explicit descriptions' do
    configuration = YAML.load <<-YAML.strip_heredoc
      Metrics/MethodLength:
        Enabled: true
        Max: 2

      Metrics/LineLength:
        Enabled: true
        Max: 3

      Metrics/BlockNesting:
        Enabled: true
        Max: 4

      Metrics/ParameterLists:
        Enabled: true
        Max: 5

      Metrics/ClassLength:
        Enabled: true
        Max: 6

      Metrics/ModuleLength:
        Enabled: true
        Max: 7
    YAML

    RubocopExplainer.new(configuration).descriptions.should match_array [
      'Най-много 2 реда на метод',
      'Най-много 3 символа на ред',
      'Най-много 4 нива на влагане',
      'Най-много 5 аргумента на метод',
      'Най-много 6 реда на клас',
      'Най-много 7 реда на модул'
    ]
  end

  it 'only considers cops present in the configuration' do
    configuration = YAML.load <<-YAML.strip_heredoc
      Metrics/MethodLength:
        Enabled: true
        Max: 10
    YAML

    RubocopExplainer.new(configuration).descriptions.should eq [
      'Най-много 10 реда на метод'
    ]
  end

  it 'ignores unknown and disabled cops' do
    configuration = YAML.load <<-YAML.strip_heredoc
      Style/MutableConstant:
        Enabled: true

      Metrics/MethodLength:
        Enabled: false
        Max: 10

      Metrics/ModuleLength:
        Max: 7
    YAML

    RubocopExplainer.new(configuration).descriptions.should eq []
  end

  it 'uses the explicit descriptions if present' do
    configuration = YAML.load <<-YAML.strip_heredoc
      Style/MutableConstant:
        Enabled: true
        Description: Трябва да се използва `freeze` на всички константи

      Metrics/MethodLength:
        Enabled: true
        Description: Методите трябва да са малки
    YAML

    RubocopExplainer.new(configuration).descriptions.should eq [
      'Трябва да се използва `freeze` на всички константи',
      'Методите трябва да са малки'
    ]
  end
end
