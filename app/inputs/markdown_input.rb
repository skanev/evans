class MarkdownInput < SimpleForm::Inputs::TextInput
  def input
    content = @builder.object.send(attribute_name) || ''
    input_html_options['data-contribution-input'] = true

    preview_area = template.content_tag(:div, Markup.format(content),
      data: {'contribution-preview' => 'true'}, class: 'contribution-preview')

    super + preview_area
  end
end
