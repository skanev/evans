module Polls
  module Question
    class Base
      attr_reader :name, :hint, :style

      def initialize(hash)
        @name     = hash[:name]
        @text     = hash[:text]
        @required = hash[:required]
        @note     = hash[:note]
        @style    = hash[:style]
      end

      def value(value)
        value
      end

      def form_options
        additional_options.reverse_merge({
          as: input_type,
          label: @text,
          hint: @note,
          wrapper_html: {class: @style},
        })
      end

      def additional_options
        {}
      end

      def required?
        @required
      end
    end
  end
end
