module Polls
  module Question
    class SingleLine < Base
      def input_type
        :string
      end
    end
  end
end
