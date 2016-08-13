module FormattedCode
  class Diff
    def initialize(from, to, language, inline_comments)
      @diff = ::Diff::LCS.sdiff(from.split("\n"), to.split("\n"))
      @html_lines = CodeRay.scan(to, language).html(wrap: nil).split("\n")

      @inline_comments = inline_comments
    end

    def lines
      @diff.flat_map do |change|
        comments_for_line = @inline_comments.fetch(change.new_position, [])
        new_highlighted_line = @html_lines[change.new_position]

        case change.action
        when '-'
          [DiffLine.new('-', change.old_element, nil, [])]
        when '+'
          [DiffLine.new('+', new_highlighted_line, change.new_position, comments_for_line)]
        when '!'
          [
            DiffLine.new('-', change.old_element, nil, []),
            DiffLine.new('+', new_highlighted_line, change.new_position, comments_for_line)
          ]
        else
          [DiffLine.new('=', new_highlighted_line, change.new_position, comments_for_line)]
        end
      end
    end
  end
end
