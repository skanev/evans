module FormattedCode
  class Code
    def initialize(code, language, inline_comments)
      @code = CodeRay.scan(code, language).html(wrap: nil)
      @inline_comments = inline_comments
    end

    def lines
      @code.split("\n").map.with_index do |line, line_number|
        comments_for_line = @inline_comments.fetch(line_number, [])

        CodeLine.new(line.html_safe, line_number, comments_for_line)
      end
    end
  end
end
