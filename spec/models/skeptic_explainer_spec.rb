require 'spec_helper'

describe SkepticExplainer do
  it "can generate the command line to run skeptic" do
    line = SkepticExplainer.command_line no_semicolon: true, line_length: 80
    line.should eq 'skeptic --no-semicolon --line-length 80 solution.rb'
  end

  it "generates properly formatted command line options for values with whitespace in them" do
    line = SkepticExplainer.command_line english_words_for_names: 'some words as exceptions', line_length: 30
    line.should eq "skeptic --english-words-for-names='some words as exceptions' --line-length 30 solution.rb"
  end

  it "can describe each restriction" do
    SkepticExplainer.restriction_name(:lines_per_method, 3).should eq 'Най-много 3 реда на метод'
    SkepticExplainer.restriction_name('no_trailing_whitespace', true).should eq 'Без whitespace на края на реда'
  end

  it "shows the restriction as a command line if not described" do
    SkepticExplainer.restriction_name(:unexisting, true).should eq '--unexisting'
    SkepticExplainer.restriction_name('unexisting', 3).should eq '--unexisting 3'
  end
end
