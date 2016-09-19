module Support
  module CommentHistoryHelpers
    def comments_from_version(code)
      current_line_index = -1
      comments = Hash.new { |hash, key| hash[key] = [] }

      code.lines.map(&:strip).each_with_index do |line, index|
        if line.start_with? '#'
          comments[current_line_index] << line.sub(/^#\s/, '')
        else
          current_line_index += 1
        end
      end

      comments
    end

    def code_from_version(code)
      code.lines.map(&:strip).reject { |line| line.start_with? '#' }.join("\n")
    end

    def code_and_comments_to_version(code, comments_by_index)
      code.lines.map(&:strip).flat_map.with_index do |line, index|
        comments = comments_by_index.fetch(index, []).map { |comment| "# #{comment}" }

        [line.strip, *comments]
      end.join("\n")
    end
  end
end
