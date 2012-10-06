module Polls
  module Question
    class Line
      attr_reader :name

      def initialize(hash)
        @name = hash[:name]
        @text = hash[:text]
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
    end
  end
end
