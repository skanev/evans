# Use this setup block to configure all options available in SimpleForm.
SimpleForm.setup do |config|
  config.wrappers tag: :div, class: :input, error_class: :field_with_errors do |wrappers|
    wrappers.use :html5
    wrappers.use :placeholder
    wrappers.use :label_input
    wrappers.use :hint, wrap_with: {tag: :span, class: :hint}
    wrappers.use :error, wrap_with: {tag: :span, class: :error}
  end
  config.label_text = lambda { |label, required| "#{label} #{required}" }
end
