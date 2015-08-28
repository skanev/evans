class DateTimeInput < SimpleForm::Inputs::Base
  FORMAT = '%Y-%m-%d %H:%M:%S'

  def input(wrapper_options)
    timestamp = @builder.object.send(attribute_name)
    formatted = timestamp.try(:strftime, FORMAT)

    options[:hint] = 1.week.from_now.strftime "Формат: #{FORMAT}"

    input_html_classes.unshift 'string'
    input_html_options[:type] = :string
    input_html_options[:value] = formatted

    @builder.text_field attribute_name, input_html_options
  end
end
