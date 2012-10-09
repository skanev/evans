module Polls
  module Question
    class MultiChoice
      attr_reader :name

      def initialize(hash)
        @name     = hash[:name]
        @text     = hash[:text]
        @required = hash[:required]
        @options  = hash[:options]
      end

      def value(value)
        value.try :reject, &:blank?
      end

      def form_options
        {
          as: :check_boxes,
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
