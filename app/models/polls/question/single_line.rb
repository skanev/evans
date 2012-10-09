module Polls
  module Question
    class SingleLine
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
        {
          as: :string,
          label: @text,
        }
      end

      def required?
        @required
      end
    end
  end
end
