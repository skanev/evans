require 'spec_helper'

describe "Parsing Python code", python: true do
  it "returns false for invalid code" do
    Language::Python.should_not be_parsing <<CODE
def class answer:
  42
CODE
  end

  it "returns true for valid code" do
    Language::Python.should be_parsing <<CODE
def answer():
  return 42
CODE
  end

  it "returns true for no code" do
    Language::Python.should be_parsing ""
  end
end
