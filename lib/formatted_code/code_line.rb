module FormattedCode
  class CodeLine
    attr_reader :html, :comments

    def initialize(html, line_number, comments_by_line)
      @html        = html
      @line_number = line_number
      @comments    = comments_by_line
    end

    def line_number
      @line_number + 1
    end

    def commentable?
      true
    end

    def html_class
    end
  end
end
