require 'spec_helper'

describe FormattedCode::Code do
  let(:highlighter) { double }

  before do
    allow(FormattedCode::Highlighter).to receive(:new) do |code, language|
      allow(highlighter).to receive(:lines).and_return code.split("\n")

      highlighter
    end
  end

  describe '#lines' do
    it 'creates a list of CodeLine objects' do
      code = FormattedCode::Code.new("source\ncode", 'ruby', [])

      allow(FormattedCode::CodeLine).to receive(:new).with('source', 0, []).and_return 'line 1'
      allow(FormattedCode::CodeLine).to receive(:new).with('code', 1, []).and_return 'line 2'

      expect(code.lines).to eq ['line 1', 'line 2']
    end

    it 'uses CodeRay for code highlighting' do
      expect(FormattedCode::Highlighter).to receive(:new)
        .with('source', 'ruby')
        .and_return(highlighter)

      expect(highlighter).to receive(:lines).and_return ['highlighted']

      allow(FormattedCode::CodeLine).to receive(:new).with('highlighted', 0, []).and_return 'line 1'

      code = FormattedCode::Code.new('source', 'ruby', [])

      expect(code.lines.first).to eq 'line 1'
    end

    it 'sets the inline comments for each line' do
      code = FormattedCode::Code.new("source\ncode", 'ruby', {
        0 => ['comment one', 'comment two'],
        1 => ['comment three']
      })

      expect(FormattedCode::CodeLine).to receive(:new)
        .with('source', 0, ['comment one', 'comment two'])
        .and_return 'line 1'

      expect(FormattedCode::CodeLine).to receive(:new)
        .with('code', 1, ['comment three'])
        .and_return 'line 2'

      expect(code.lines).to eq ['line 1', 'line 2']
    end
  end
end
