require 'spec_helper'

describe FormattedCode::Code do
  include Support::CommentHistoryHelpers

  before do
    allow(FormattedCode::Highlighter).to receive(:new) do |code, language|
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

    expect(first_line.html).to eq 'Formatted First line'
    expect(first_line.line_number).to eq 1
    expect(first_line.comments).to eq ['Comment one', 'Comment two']
    expect(first_line).to be_commentable

    expect(second_line.html).to eq 'Formatted Second line'
    expect(second_line.line_number).to eq 2
    expect(second_line.comments).to eq ['Comment three']
    expect(second_line).to be_commentable
  end
end
