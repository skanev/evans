require 'spec_helper'

describe FormattedCode::Code do
  include Support::CommentHistoryHelpers

  before do
    FormattedCode::Highlighter.stub :new do |code, language|
      double lines: code.split("\n").map { |line| "Formatted #{line}" }
    end
  end

  it 'highlights the code and splits it in lines' do
    version = <<-END
      First line
      # Comment one
      # Comment two
      Second line
      # Comment three
    END

    code  = FormattedCode::Code.new(code_from_version(version), 'ruby', comments_from_version(version))
    lines = code.lines

    first_line  = lines.first
    second_line = lines.second

    first_line.html.should eq 'Formatted First line'
    first_line.line_number.should eq 1
    first_line.comments.should eq ['Comment one', 'Comment two']
    first_line.should be_commentable

    second_line.html.should eq 'Formatted Second line'
    second_line.line_number.should eq 2
    second_line.comments.should eq ['Comment three']
    second_line.should be_commentable
  end
end
