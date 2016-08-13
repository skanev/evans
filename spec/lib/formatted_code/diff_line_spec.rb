require 'spec_helper'

describe FormattedCode::DiffLine do
  it 'is a CodeLine' do
    expect(FormattedCode::DiffLine).to be < FormattedCode::CodeLine
  end

  describe '#line_number' do
    it 'is the line index incremented by one for unchanged lines' do
      line = FormattedCode::DiffLine.new('=', 'source', 33, [])

      expect(line.line_number).to eq 34
    end

    it 'is the line index incremented by one for added lines' do
      line = FormattedCode::DiffLine.new('+', 'source', 33, [])

      expect(line.line_number).to eq 34
    end

    it 'is blank for removed lines' do
      line = FormattedCode::DiffLine.new('-', 'source', 33, [])

      expect(line.line_number).to be_blank
    end
  end

  describe '#html' do
    it 'prefixes the source with `+` if the change type is addition' do
      line = FormattedCode::DiffLine.new('+', 'source', 0, [])

      expect(line.html).to eq '+source'
    end

    it 'prefixes the source with `-` if the change type is removal' do
      line = FormattedCode::DiffLine.new('-', 'source', 0, [])

      expect(line.html).to eq '-source'
    end

    it 'prefixes the source with ` ` if the line is unchanged' do
      line = FormattedCode::DiffLine.new('=', 'source', 0, [])

      expect(line.html).to eq ' source'
    end

    it 'is html safe' do
      line = FormattedCode::DiffLine.new('=', 'source', 0, [])

      expect(line.html).to be_html_safe
    end
  end

  describe '#commentable?' do
    it 'is true for added lines' do
      line = FormattedCode::DiffLine.new('+', 'source', 0, [])

      expect(line).to be_commentable
    end

    it 'is true for unchanged lines' do
      line = FormattedCode::DiffLine.new('=', 'source', 0, [])

      expect(line).to be_commentable
    end

    it 'is false for removed lines' do
      line = FormattedCode::DiffLine.new('-', 'source', 0, [])

      expect(line).to_not be_commentable
    end
  end
end
