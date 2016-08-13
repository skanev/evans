require 'spec_helper'

describe FormattedCode::Diff do
  before do
    allow(CodeRay).to receive(:scan) do |code, language|
      code_ray = double

      allow(code_ray).to receive(:html).with(wrap: nil).and_return code

      code_ray
    end
  end

  describe '#lines' do
    it 'creates a list of CodeLine objects with line numbers for the new code' do
      code = FormattedCode::Diff.new("source\ncode", "destination\ncode", 'ruby', [])

      allow(FormattedCode::DiffLine).to receive(:new)
        .with('-', 'source', nil, [])
        .and_return 'line 1'

      allow(FormattedCode::DiffLine).to receive(:new)
        .with('+', 'destination', 0, [])
        .and_return 'line 2'

      allow(FormattedCode::DiffLine).to receive(:new)
        .with('=', 'code', 1, [])
        .and_return 'line 3'

      expect(code.lines).to eq ['line 1', 'line 2', 'line 3']
    end

    it 'uses CodeRay to highlight the new code' do
      code_ray = double

      expect(CodeRay).to receive(:scan).with('source', 'ruby').and_return(code_ray)
      expect(code_ray).to receive(:html).with(wrap: nil).and_return('code')

      allow(FormattedCode::DiffLine).to receive(:new).with('-', 'old', nil, []).and_return 'line 1'
      allow(FormattedCode::DiffLine).to receive(:new).with('+', 'code', 0, []).and_return 'line 2'

      code = FormattedCode::Diff.new('old', 'source', 'ruby', [])

      expect(code.lines).to eq ['line 1', 'line 2']
    end

    it 'sets the inline comments for each line of the new code' do
      code = FormattedCode::Diff.new("source\ncode", "destination\ncode", 'ruby', {
        0 => ['comment one', 'comment two'],
        1 => ['comment three']
      })

      expect(FormattedCode::DiffLine).to receive(:new)
        .with('-', 'source', nil, [])
        .and_return 'line 1'

      expect(FormattedCode::DiffLine).to receive(:new)
        .with('+', 'destination', 0, ['comment one', 'comment two'])
        .and_return 'line 2'

      expect(FormattedCode::DiffLine).to receive(:new)
        .with('=', 'code', 1, ['comment three'])
        .and_return 'line 3'

      expect(code.lines).to eq ['line 1', 'line 2', 'line 3']
    end
  end
end
