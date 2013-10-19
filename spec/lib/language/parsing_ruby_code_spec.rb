require 'spec_helper'

describe "Parsing Ruby code", ruby: true do
  it "returns false for invalid code" do
    Language::Ruby.parses?(<<-END).should be_false
def answer()
  42
END
  end

  it "returns true for valid code" do
    Language::Ruby.parses?(<<-END).should be_true
def answer()
  42
end
END
  end

  it "returns true for no code" do
    Language::Ruby.parses?("").should be_true
  end
end
