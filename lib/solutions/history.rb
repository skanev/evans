module Solutions
  class History
    attr_reader :last_revision

    def initialize(solution)
      @solution = solution
      @last_revision = build_history
    end

    def revisions_count
      @solution.revisions.size
    end

    def comments_count
      @solution.comments.size
    end

    def revisions
      return [] unless @last_revision

      @last_revision.revisions
    end

    private

    def build_history
      @solution.revisions.reduce(nil) do |history, revision|
        Solutions::Revision.new(history, revision)
      end
    end
  end
end
