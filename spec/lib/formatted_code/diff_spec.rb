require 'spec_helper'

describe FormattedCode::Diff do
  include Support::CommentHistoryHelpers

  before do
    FormattedCode::Highlighter.stub :new do |code, language|
      double lines: code.split("\n").map { |line| "!#{line}" }
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
      +!New line
      # Comment one
      # Comment two
       !Code
      # Comment three
    END

    first_line, second_line, third_line = diff_lines(old_version, new_version)

    expect(first_line.line_number).to eq ' '
    expect(first_line.html_class).to eq 'removed'
    expect(first_line).to_not be_commentable

    expect(second_line.line_number).to eq 1
    expect(second_line.html_class).to eq 'added'
    expect(second_line).to be_commentable

    expect(third_line.line_number).to eq 2
    expect(third_line).to be_commentable
  end

  it 'does not interleave sequences of changed lines' do
    old_version = <<-END
      puts one
      puts two
      puts three
      puts 42
    END

    new_version = <<-END
      puts first
      puts second
      puts third
      puts 42
      # This is much better
    END

    expect_diff old_version, new_version, <<-END
      -puts one
      -puts two
      -puts three
      +!puts first
      +!puts second
      +!puts third
       !puts 42
       # This is much better
    END
  end

  it 'escapes code lines that do not pass through the highlighter' do
    old_version = <<-END
      puts <div>
    END

    new_version = <<-END
    END

    expect_diff old_version, new_version, <<-END
      -puts &lt;div&gt;
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
