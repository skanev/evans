module Polls
  module Question
    class SingleChoice
      attr_reader :name

      def initialize(hash)
        @name     = hash[:name]
        @text     = hash[:text]
        @required = hash[:required]
        @options  = hash[:options]
      end

      def value(value)
        value
      end

      def form_options
        {
          as: :radio_buttons,
          label: @text,
          collection: @options,
        }
      end

      def required?
        @required
      end
    end
  end
end
