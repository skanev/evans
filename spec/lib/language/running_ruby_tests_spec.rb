require 'spec_helper'

describe "Running Ruby tests", ruby: true do
  before :all do
    @test_case_code = <<END.strip
describe "Homework" do
  it("succeeds once")   { true.should be_true }
  it("succeeds thrice") { puts "Just to mess with you" }
  it("fails once")      { true.should be_false }
  it("succeeds twice")  { Homework.answer.should eq 42 }
  it("fails twice")     { 1.should eq 2 }
  it("errors once")     { raise RuntimeError }
end
END
  end

  it "handles solutions that raise a runtime error" do
    solution = 'require "intertools"'
    results = Language::Ruby.run_tests(@test_case_code, solution)

    results.passed_count.should eq 0
    results.failed_count.should eq 0
  end

  describe "on successful run" do
    before(:all) do
      solution = <<-EOF
        module Homework
          def self.answer; 42; end
          puts "Another puts"
        end
      EOF
      @results = Language::Ruby.run_tests(@test_case_code, solution)
    end

    it "calculates the number of passed tests" do
      @results.passed_count.should eq 3
    end

    it "calculates the number of failed tests" do
      @results.failed_count.should eq 3
    end

    it "collects the execution log" do
      @results.log.should include("6 examples, 3 failures")
    end
  end
end
