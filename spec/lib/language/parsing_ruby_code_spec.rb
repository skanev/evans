require 'spec_helper'

describe "Parsing Ruby code", ruby: true do
  it "returns false for invalid code" do
    invalid_code = <<END.strip
def answer()
  42
END
    Language::Ruby.parses?(invalid_code).should be_false
  end

  it "returns true for valid code" do
    valid_code = <<END.strip
def answer()
  42
end
END
    Language::Ruby.parses?(valid_code).should be_true
  end

  it "returns true for no code" do
    Language::Ruby.parses?("").should be_true
  end
end
