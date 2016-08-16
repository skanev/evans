module FormattedCode
  class Code
    def initialize(code, language, inline_comments)
      @highlighter = Highlighter.new(code, language)
      @inline_comments = inline_comments
    end

    def lines
      @highlighter.lines.map.with_index do |line, line_number|
        comments_for_line = @inline_comments.fetch(line_number, [])

        CodeLine.new(line.html_safe, line_number, comments_for_line)
      end
    end
  end
end
