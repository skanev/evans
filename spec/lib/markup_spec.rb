require 'spec_helper'

describe Markup do
  def format(input)
    Markup.format(input).strip
  end

  it "makes *this_string* emphasized" do
    format('*this_string*').should include('<p><em>this_string</em></p>')
  end

  it "converts `backticked strings` to code blocks" do
    format('`foo()`').should include('<code>foo()</code>')
  end

  it "removes adds nofollow to hyperlinks" do
    input = '<a href="#" onclick="maliciousCode()">link</a>'
    output = '<a href="#">link</a>'

    format(input).should include(output)
  end

  it "removes script tags" do
    input = '<script type="text/javascript">maliciousCode()</script>'

    format(input).should_not include('<script')
  end

  it "generates an html safe string" do
    format('').should be_html_safe
  end

  it "allows setting class on <pre>" do
    format('<pre class="baba"></pre>').should include('<pre class="baba"></pre>')
  end
end
