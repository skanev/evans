require 'spec_helper'

describe FormattedCode::CommentHistory do
  include Support::CommentHistoryHelpers

  it 'only preserves comments on unchanged lines' do
    version_one = <<-END
      Line one
      # Comment one
      # Comment two
      Line two
      # Comment three
    END

    version_two = <<-END
      Line one
      Changed line
    END

    expected = <<-END
      Line one
      # Comment one
      # Comment two
      Changed line
    END

    expect_comments_to_match version_one, version_two, expected
  end

  it 'preserves all comments on the last version' do
    single_version = <<-END
      Line one
      # Comment one
      Line two
      # Comment two
    END

    expected = <<-END
      Line one
      # Comment one
      Line two
      # Comment two
    END

    expect_comments_to_match single_version, expected
  end

  it 'moves comments to the correct line' do
    version_one = <<-END
      Line one
      # Comment one
      # Comment two
      Line two
    END

    version_two = <<-END
      Line zero
      Line one
      Changed line
    END

    expected = <<-END
      Line zero
      Line one
      # Comment one
      # Comment two
      Changed line
    END

    expect_comments_to_match version_one, version_two, expected
  end

  it 'combines comments on the same line' do
    version_one = <<-END
      Line one
      # Comment one
      # Comment two
      Line two
    END

    version_two = <<-END
      Line zero
      Line one
      # Comment three
      Changed line
    END

    expected = <<-END
      Line zero
      Line one
      # Comment one
      # Comment two
      # Comment three
      Changed line
    END

    expect_comments_to_match version_one, version_two, expected
  end

  def expect_comments_to_match(*versions, expected)
    history = FormattedCode::CommentHistory.new

    versions.each do |version|
      code     = code_from_version(version)
      comments = comments_from_version(version)

      history.add_version code, comments
    end

    final_code     = code_from_version(versions.last)
    final_comments = history.combined_comments

    actual = code_and_comments_to_version(final_code, final_comments)

    expect(actual).to eq expected.lines.map(&:strip).join("\n")
  end
end
