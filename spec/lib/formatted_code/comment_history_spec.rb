require 'spec_helper'

describe FormattedCode::CommentHistory do
  include Support::CommentHistoryHelpers

  it 'only preserves comments on unchanged lines' do
    version_one = <<-END
      def print_foo(foo)
      # Can you change this to bar?
      # Nope
        p foo
      # Use puts for regular printing
      end
    END

    version_two = <<-END
      def print_foo(foo)
        puts foo
      end
    END

    expected = <<-END
      def print_foo(foo)
      # Can you change this to bar?
      # Nope
        puts foo
      end
    END

    expect_comments_to_match version_one, version_two, expected
  end

  it 'preserves all comments on the last version' do
    single_version = <<-END
      def print_foo(foo)
      # Please change this to bar
        puts foo
      # Also change this
      end
    END

    expected = <<-END
      def print_foo(foo)
      # Please change this to bar
        puts foo
      # Also change this
      end
    END

    expect_comments_to_match single_version, expected
  end

  it 'moves comments to the correct line' do
    version_one = <<-END
      answer = 42
      # Is this really the answer?
      # Yes, it is
      puts answer
    END

    version_two = <<-END
      question = 'life, universe and everything'
      answer = 42
      puts "\#{question}: \#{answer}"
    END

    expected = <<-END
      question = 'life, universe and everything'
      answer = 42
      # Is this really the answer?
      # Yes, it is
      puts "\#{question}: \#{answer}"
    END

    expect_comments_to_match version_one, version_two, expected
  end

  it 'combines comments on the same line' do
    version_one = <<-END
      question = 'life, universe and everything'
      # Should this be an array?
      # No, I like it as string.
      puts question
    END

    version_two = <<-END
      answer = 42
      question = 'life, universe and everything'
      # I really think this should be an array
      puts "\#{question}: \#{answer}"
    END

    expected = <<-END
      answer = 42
      question = 'life, universe and everything'
      # Should this be an array?
      # No, I like it as string.
      # I really think this should be an array
      puts "\#{question}: \#{answer}"
    END

    expect_comments_to_match version_one, version_two, expected
  end

  it 'correctly matches the lines when there are multiple changed lines in a row' do
    version_one = <<-END
      [
        :one,
        :two,
      # Can you change this to second?
        :three,
      # Can you change this to third?
      ]
    END

    version_two = <<-END
      [
        :first,
      # Nice!
        :second,
        :three,
      # Why didn't you change this?
      ]
    END

    expected = <<-END
      [
        :first,
      # Nice!
        :second,
        :three,
      # Can you change this to third?
      # Why didn't you change this?
      ]
    END

    expect_comments_to_match version_one, version_two, expected
  end

  it 'works across multiple revisions' do
    version_one = <<-END
      answer = 42
      another_answer = answer + 1
    END

    version_two = <<-END
      answer = 43
      # This is not the correct answer
      another_answer = answer + 1
    END

    version_three = <<-END
      answer = 43
      # I disagree
      another_answer = answer - 1
      # This is the correct answer
    END

    expected = <<-END
      answer = 43
      # This is not the correct answer
      # I disagree
      another_answer = answer - 1
      # This is the correct answer
    END

    expect_comments_to_match version_one, version_two, version_three, expected
  end

  it 'compares version pairs step by step, ignoring old comments' do
    version_one = <<-END
      answer = 42
      # Correct
    END

    version_two = <<-END
      answer = 43
      # This is not right, change it back!
    END

    version_three = <<-END
      answer = 42
      # Thank you
    END

    expected = <<-END
      answer = 42
      # Thank you
    END

    expect_comments_to_match version_one, version_two, version_three, expected
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

    expect(actual).to eq expected.lines.map(&:strip).reject(&:empty?).join("\n")
  end
end
