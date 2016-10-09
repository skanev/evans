module FormattedCode
  class DiffLine
    attr_reader :comments

    def initialize(change_type, html, line_index, comments_by_line)
      @change_type = change_type
      @html        = html
      @line_index  = line_index
      @comments    = comments_by_line
    end

    def html
      "#{prefix}#{@html}".html_safe
    end

    def commentable?
      @change_type != '-'
    end

    def html_class
      case @change_type
      when '-' then 'removed'
      when '+' then 'added'
      end
    end

    def line_number
      return ' ' if @change_type == '-'

      @line_index + 1
    end

    private

    def prefix
      return ' ' if @change_type == '='

      @change_type
    end
  end
end
