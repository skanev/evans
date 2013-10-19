require 'spec_helper'

describe "Parsing Python code", python: true do
  it "returns false for invalid code" do
    invalid_code = <<END.strip
def class answer:
  42
END
    Language::Python.parses?(invalid_code).should be_false
  end

  it "returns true for valid code" do
    valid_code = <<END.strip
def answer():
  return 42
END
    Language::Python.parses?(valid_code).should be_true
  end

  it "returns true for no code" do
    Language::Python.parses?("").should be_true
  end
end
