require 'spec_helper'

describe "Parsing Go code", go: true do
  it "returns false for invalid code" do
    expect(Language::Go).not_to be_parsing <<CODE
package main

function main {
}
CODE
  end

  it "returns false for build errors" do
    expect(Language::Go).not_to be_parsing <<CODE
package main

import "fmt"

func main() {
  // unused "fmt"
}
CODE
  end

  it "returns true for valid code" do
    expect(Language::Go).to be_parsing <<CODE
package main

func main() {
}
CODE
  end

  it "returns true for valid code without a main function" do
    expect(Language::Go).to be_parsing <<CODE
package main
CODE
  end

  it "returns true for no code" do
    expect(Language::Go).to be_parsing ""
  end
end
