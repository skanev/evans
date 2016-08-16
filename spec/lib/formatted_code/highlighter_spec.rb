require 'spec_helper'

describe FormattedCode::Highlighter do
  describe '#lines' do
    it 'uses CodeRay to highlight the code and splits it in lines' do
      code_ray = double

      expect(CodeRay).to receive(:scan).with('code', 'ruby').and_return(code_ray)
      expect(code_ray).to receive(:html).with(wrap: nil).and_return("highlighted\ncode")

      highlighter = FormattedCode::Highlighter.new('code', 'ruby')

      expect(highlighter.lines).to eq ['highlighted', 'code']
    end
  end
end
