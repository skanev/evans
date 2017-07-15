require 'spec_helper'

describe "Parsing Rust code", rust: true do
  it "returns false for invalid code" do
    Language::Rust.should_not be_parsing <<CODE
    fn main(
CODE
  end

  it "returns false for build errors" do
    Language::Rust.should_not be_parsing <<CODE
fn foo() {
  // unused
}
CODE
  end

  it "returns true for valid code" do
    Language::Rust.should be_parsing <<CODE
fn main() {

}
CODE
  end

  it "returns true for valid code without a main function" do
    Language::Rust.should be_parsing <<CODE
pub fn foo() {

}
CODE
  end

  it "returns true for no code" do
    Language::Rust.should be_parsing ""
  end
end
