require 'spec_helper'

describe "Parsing Go code", go: true do
  it "returns false for invalid code" do
    Language::Go.parses?(<<-END).should be_false
package main

function main {
}
END
  end

  it "returns true for valid code" do
    Language::Go.parses?(<<-END).should be_true
package main

func main() {
}
END
  end

  it "returns true for no code" do
    Language::Go.parses?("").should be_true
  end
end
