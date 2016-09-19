require 'spec_helper'

describe FormattedCode::Diff do
  include Support::CommentHistoryHelpers

  before do
    FormattedCode::Highlighter.stub :new do |code, language|
      double lines: code.split("\n").map { |line| "Formatted #{line}" }
    end
  end

  it 'highlights the code, diffs it and splits it in lines' do
    comments = {0 => ['one', 'two'], 1 => ['three']}

    first_version = <<-END
      Old line
      Code
    END

    second_version = <<-END
      New line
      # Comment one
      # Comment two
      Code
      # Comment three
    END

    code = FormattedCode::Diff.new(
      code_from_version(first_version),
      code_from_version(second_version),
      'ruby',
      comments_from_version(second_version)
    )
    lines = code.lines

    first_line  = lines.first
    second_line = lines.second
    third_line  = lines.third

    first_line.html.should        eq '-Old line'
    first_line.line_number.should eq ' '
    first_line.comments.should    be_empty
    first_line.html_class.should  eq 'removed'
    first_line.should_not         be_commentable

    second_line.html.should        eq '+Formatted New line'
    second_line.line_number.should eq 1
    second_line.comments.should    eq ['Comment one', 'Comment two']
    second_line.html_class.should  eq 'added'
    second_line.should             be_commentable

    third_line.html.should        eq ' Formatted Code'
    third_line.line_number.should eq 2
    third_line.comments.should    eq ['Comment three']
    third_line.should             be_commentable
  end
end
