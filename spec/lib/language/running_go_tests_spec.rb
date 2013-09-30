require 'spec_helper'

describe "Running Go tests", go: true do
  before(:all) do
    @test_case_code = <<END.strip
package main

import (
    "testing"
)

func TestOne(t *testing.T) {
    if 1 == 2 {
        t.Error("Should not be seen")
    }
}

func TestTwo(t *testing.T) {
    if 1 == 1 {
        t.Error("Expected failure")
    }
}

func TestThree(t *testing.T) {
    if 2 == 1 {
        t.Error("Also should not be seen")
    }
}
END
  end

  describe "on successful run" do
    before(:all) do
      solution = <<-EOF
package main
      EOF
      @results = Language::Go.run_tests(@test_case_code, solution)
    end

    it "calculates the number of passed tests" do
      @results.passed_count.should eq 2
    end

    it "calculates the number of failed tests" do
      @results.failed_count.should eq 1
    end

    it "collects the execution log" do
      @results.log.should include("FAIL: TestTwo")
      @results.log.should include("PASS")
    end
  end
end
