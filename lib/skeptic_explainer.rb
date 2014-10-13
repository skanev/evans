module SkepticExplainer
  extend self

  RESTRICTIONS = {
    no_semicolons:            'Не ползвайте ; за да разделяте изрази',
    max_nesting_depth:        'Най-много %d нива на влагане',
    lines_per_method:         'Най-много %d реда на метод',
    methods_per_class:        'Най-много %d метода в клас',
    line_length:              'Най-много %d символа на ред',
    max_method_arity:         'Най-много %d аргумента на метод',
    no_trailing_whitespace:   'Без whitespace на края на реда',
    check_syntax:             'Изисква валиден синтаксис',
    no_global_variables:      'Забранява използването на глобални променливи',
    english_words_for_names:  'Изисква да ползвате само комбинации валидни английски думи за именуване, със следните изключения: %s',
    naming_conventions:       'Налага спазване на конвенциите за именуване',
    spaces_around_operators:  'Налага спазване на конвенциите за поставяне на интервали около оператори',
  }.with_indifferent_access

  def restriction_name(rule, option)
    if RESTRICTIONS.has_key? rule
      RESTRICTIONS[rule] % [option]
    else
      restriction_paremeter(rule, option)
    end
  end

  def command_line(restrictions)
    options = restrictions.
      map { |rule, option| restriction_paremeter(rule, option) }.
      join(' ')

    "skeptic #{options} solution.rb"
  end

  private

  def restriction_paremeter(rule, option)
    rule_name = "--#{rule.to_s.dasherize}"

    case option
      when false    then nil
      when true     then rule_name
      when Integer  then "#{rule_name} #{option}"
      else               "#{rule_name}='#{option}'"
    end
  end
end
