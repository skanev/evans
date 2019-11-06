require 'spec_helper'

describe Markup do
  def format(input)
    Markup.format(input).strip
  end

  it "makes *this_string* emphasized" do
    expect(format('*this_string*')).to include('<p><em>this_string</em></p>')
  end

  it "converts `backticked strings` to code blocks" do
    expect(format('`foo()`')).to include('<code>foo()</code>')
  end

  it "removes adds nofollow to hyperlinks" do
    input = '<a href="#" onclick="maliciousCode()">link</a>'
    output = '<a href="#">link</a>'

    expect(format(input)).to include(output)
  end

  it "removes script tags" do
    input = '<script type="text/javascript">maliciousCode()</script>'

    format(input).should_not include('<script')
  end

  it "generates an html safe string" do
    expect(Markup.format('')).to be_html_safe
  end

  it "preserves embedded LaTeX" do
    expect(Markup.format("$$ _foo_ \n _bar_ $$")).to eq "<p>$$ _foo_ \n _bar_ $$</p>\n"
  end

  it "allows setting class on <pre>" do
    expect(format('<pre class="baba"></pre>')).to include('<pre class="baba"></pre>')
  end

  describe "(emoji)" do
    def image_tag(slug)
      %{<img src="#{Markup.emoji_url(slug)}" alt=":#{slug}:" class="emoji" />}
    end

    it "converts emoji emoticons" do
      expect(format(':hammer:')).to include image_tag(:hammer)
    end

    it "does not convert emoji within <code> blocks" do
      format('<code>:hammer:</code>').should_not include image_tag(:hammer)
    end

    it "converts emoji betweeen two code tags" do
      expect(format('<code>:smile:</code>:hammer:<code>:smile:</code>')).to include image_tag(:hammer)
      expect(format('<code>:smile:</code>:hammer:<code>:smile:</code>')).to_not include image_tag(:smile)
    end

    it "does not convert emoji in multiline code blocs" do
      format(<<-END).should_not include image_tag(:hammer)
        ```
          :hammer:
        ```
      END
    end
  end
end
