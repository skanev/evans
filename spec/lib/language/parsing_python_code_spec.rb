require 'spec_helper'

describe "Parsing Python code", python: true do
  it "returns false for invalid code" do
    Language::Python.parses?(<<-END).should be_false
def class answer:
  42
END
  end

  it "returns true for valid code" do
    Language::Python.parses?(<<-END).should be_true
def answer():
  return 42
END
  end

  it "returns true for no code" do
    Language::Python.parses?("").should be_true
  end
end
