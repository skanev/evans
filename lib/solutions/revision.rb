module Solutions
  class Revision
    attr_reader :parent, :model

    delegate :id, :created_at, :code, to: :model

    def initialize(parent, model)
      @model = model
      @parent = parent
    end

    def first_revision?
      @parent.nil?
    end

    def revisions
      enum_for :each_revision
    end

    def formatted_code
      FormattedCode::Code.new @model.code, Language.language, inline_comments
    end

    def formatted_diff
      FormattedCode::Diff.new parent_code, @model.code, Language.language, inline_comments_on_self
    end

    def comments
      @model.comments.non_inline
    end

    def inline_comments_on_self
      @model.comments.inline.group_by(&:line_number)
    end

    def inline_comments
      @inline_comments ||= inline_comments_on_parent.merge(inline_comments_on_self) { |_, a, b| a + b }
    end

    private

    def inline_comments_on_parent
      return {} if first_revision?

      comments = @parent.inline_comments

      diff.select(&:unchanged?).map do |change|
        comments_for_line = comments.fetch(change.old_position, [])

        if comments_for_line.any?
          [change.new_position, comments_for_line]
        else
          nil
        end
      end.compact.to_h
    end

    def each_revision(&block)
      parent.revisions.each &block if parent

      yield self
    end

    def parent_code
      return '' if first_revision?

      parent.code
    end

    def diff
      @diff ||= Diff::LCS.sdiff(parent_code.lines, model.code.lines)
    end
  end
end
