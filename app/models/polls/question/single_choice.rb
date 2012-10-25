module Polls
  module Question
    class SingleChoice < Base
      def initialize(hash)
        super
        @options  = hash[:options]
      end

      def input_type
        :radio_buttons
      end

      def additional_options
        {collection: @options}
      end
    end
  end
end
