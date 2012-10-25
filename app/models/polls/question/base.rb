module Polls
  module Question
    class Base
      attr_reader :name

      def initialize(hash)
        @name     = hash[:name]
        @text     = hash[:text]
        @required = hash[:required]
      end

      def value(value)
        value
      end

      def form_options
        additional_options.reverse_merge({
          as: input_type,
          label: @text,
        })
      end

      def additional_options
        {}
      end

      def input_type
        raise NotImplementedError
      end

      def required?
        @required
      end
    end
  end
end
