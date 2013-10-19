require 'spec_helper'

describe "Parsing Ruby code", ruby: true do
  before :all do
    @invalid_code = <<END.strip
def answer()
  42
END

    @valid_code = <<END.strip
def answer()
  42
end
END

    @empty_code = <<END.strip
END
  end

  it "returns false for invalid code" do
    Language::Ruby.parses?(@invalid_code).should be_false
  end

  it "returns true for valid code" do
    Language::Ruby.parses?(@valid_code).should be_true
  end

  it "returns true for no code" do
    Language::Ruby.parses?(@empty_code).should be_true
  end
end
