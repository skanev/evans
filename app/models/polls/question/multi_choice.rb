module Polls
  module Question
    class MultiChoice < Base
      def initialize(hash)
        super
        @options  = hash[:options]
      end

      def value(value)
        value.try :reject, &:blank?
      end

      def input_type
        :check_boxes
      end

      def additional_options
        {collection: @options}
      end
    end
  end
end
