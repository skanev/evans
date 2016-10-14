module FormattedCode
  class Differ
    def initialize(old_code, new_code)
      @old_lines = old_code.split("\n")
      @new_lines = new_code.split("\n")
    end

    def changes
      enum_for :each_change
    end

    private

    def each_change(&block)
      ::Diff::LCS.traverse_sequences(@old_lines, @new_lines, &block)
    end
  end
end
