require 'spec_helper'

describe FormattedCode::Highlighter do
  it 'highlights the code and split it in lines' do
    highlighter = FormattedCode::Highlighter.new("42\n1.abs", 'ruby')

    highlighter.lines.should eq [
      '<span class="mi">42</span>',
      '<span class="mi">1</span><span class="p">.</span><span class="nf">abs</span>'
    ]
  end

  it 'does not break when the language is not supported' do
    highlighter = FormattedCode::Highlighter.new("42\n1.abs", 'undefined')

    highlighter.lines.should eq [
      '42',
      '1.abs'
    ]
  end

  it 'escapes html entities' do
    highlighter = FormattedCode::Highlighter.new("<3", 'undefined')

    highlighter.lines.should eq ['&lt;3']
  end
end
