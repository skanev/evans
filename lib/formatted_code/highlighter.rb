module FormattedCode
  class Highlighter
    def initialize(source, language)
      @source = source
      @language = language
    end

    def lines
      @lines ||=
        begin
          tokens = lexer.lex(@source)
          formatter = Rouge::Formatters::HTML.new

          HTMLLineFormatter.new(formatter).lines_for(tokens).to_a
        end
    end

    private

    def lexer
      Rouge::Lexer.find(@language) || Rouge::Lexers::PlainText
    end
  end

  class HTMLLineFormatter < Rouge::Formatter
    def initialize(formatter, opts={})
      @formatter = formatter
    end

    def lines_for(tokens)
      enum_for :stream, tokens
    end

    def stream(tokens)
      token_lines(tokens) do |line|
        html_line = line.map do |token, value|
          @formatter.span(token, value)
        end.join('')

        yield html_line
      end
    end
  end
end
