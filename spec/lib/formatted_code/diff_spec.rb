require 'spec_helper'

describe FormattedCode::Diff do
  include Support::CommentHistoryHelpers

  before do
    FormattedCode::Highlighter.stub :new do |code, language|
      double lines: code.split("\n").map { |line| "Formatted #{line}" }
    end
  end

  it 'highlights the code, diffs it and displays comments' do
    old_version = <<-END
      Old line
      Code
    END

    new_version = <<-END
      New line
      # Comment one
      # Comment two
      Code
      # Comment three
    END

    expect_diff old_version, new_version, <<-END
      -Old line
      +Formatted New line
      # Comment one
      # Comment two
       Formatted Code
      # Comment three
    END

    first_line, second_line, third_line = diff_lines(old_version, new_version)

    first_line.line_number.should eq ' '
    first_line.html_class.should eq 'removed'
    first_line.should_not be_commentable

    second_line.line_number.should eq 1
    second_line.html_class.should eq 'added'
    second_line.should be_commentable

    third_line.line_number.should eq 2
    third_line.should be_commentable
  end

  it 'does not interleave sequences of changed lines' do
    old_version = <<-END
      Old line 1
      Old line 2
      Old line 3
      Code
    END

    new_version = <<-END
      New line 1
      New line 2
      New line 3
      # Comment one
      Code
      # Comment two
    END

    expect_diff old_version, new_version, <<-END
      -Old line 1
      -Old line 2
      -Old line 3
      +Formatted New line 1
      +Formatted New line 2
      +Formatted New line 3
      # Comment one
      Formatted Code
      # Comment two
    END
  end

  def diff_lines(old_version, new_version)
    FormattedCode::Diff.new(
      code_from_version(old_version),
      code_from_version(new_version),
      'ruby',
      comments_from_version(new_version)
    ).lines
  end

  def expect_diff(old_version, new_version, expected_diff)
    lines    = diff_lines(old_version, new_version)
    diff     = lines.map(&:html).join("\n")
    comments = lines.map.with_index { |line, index| [index, line.comments] }.to_h

    actual_diff = code_and_comments_to_version(diff, comments)

    expect(actual_diff).to eq expected_diff.lines.map(&:strip).join("\n")
  end
end
