# encoding: utf-8
module TasksHelper
  def restriction_name(rule, option)
    case rule.to_sym
      when :no_semicolons     then 'Не ползвайте ; за да разделяте изрази'
      when :max_nesting_depth then "Най-много #{pluralize(option, 'ниво', 'нива')} на влагане"
      when :lines_per_method  then "Най-много #{option} реда на метод"
      when :methods_per_class then "Най-много #{option} метода в клас"
      else "--#{rule.underscore} #{option}"
    end
  end

  def skeptic_command_line(restrictions)
    options = restrictions
      .map { |rule, option| "--#{rule.dasherize} #{option}".gsub(/ true$/, '') }
      .join(' ')

    "skeptic #{options} solution.rb"
  end
end
