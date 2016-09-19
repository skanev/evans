require 'spec_helper'

describe FormattedCode::Highlighter do
  describe '#lines' do
    it 'uses CodeRay to highlight the code and splits it in lines' do
      code_ray = double

      CodeRay.should_receive(:scan).with('code', 'ruby').and_return(code_ray)
      code_ray.should_receive(:html).with(wrap: nil).and_return("highlighted\ncode")

      highlighter = FormattedCode::Highlighter.new('code', 'ruby')

      highlighter.lines.should eq ['highlighted', 'code']
    end
  end
end
