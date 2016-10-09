module FormattedCode
  class Highlighter
    attr_reader :lines

    def initialize(code, language)
      @lines = CodeRay.scan(code, language).html(wrap: nil).split("\n")
    end
  end
end
