module FormattedCode
  class DiffLine < CodeLine
    def initialize(change_type, *args)
      super *args

      @change_type = change_type
    end

    def html
      "#{prefix}#{super}".html_safe
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

      @line_number + 1
    end

    private

    def prefix
      return ' ' if @change_type == '='

      @change_type
    end
  end
end
