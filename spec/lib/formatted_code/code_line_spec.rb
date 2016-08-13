require 'spec_helper'

describe FormattedCode::CodeLine do
  subject(:line) { FormattedCode::CodeLine.new('code html', 11, ['comment']) }

  describe '#html' do
    it 'returns the html formatted code' do
      expect(line.html).to eq 'code html'
    end
  end

  describe '#line_number' do
    it 'returns the line number incremented by one' do
      expect(line.line_number).to eq 12
    end
  end

  describe '#comments' do
    it 'returns the line comments' do
      expect(line.comments).to eq ['comment']
    end
  end

  describe '#commentable?' do
    it 'is true' do
      expect(line).to be_commentable
    end
  end

  describe '#html_class' do
    it 'is blank' do
      expect(line.html_class).to be_blank
    end
  end
end
