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

  it "does not depend on the CWD" do
    solution = 'package main'

    Dir.mktmpdir do |dir|
      Dir.chdir(dir) do
        results = Language::Go.run_tests(@test_case_code, solution)

        expect(results.log).to include("FAIL: TestTwo")
      end
    end
  end

  describe "on successful run" do
    before(:all) do
      solution = <<-EOF
package main
      EOF
      @results = Language::Go.run_tests(@test_case_code, solution)
    end

    it "calculates the number of passed tests" do
      expect(@results.passed_count).to eq 2
    end

    it "calculates the number of failed tests" do
      expect(@results.failed_count).to eq 1
    end

    it "collects the execution log" do
      expect(@results.log).to include("FAIL: TestTwo")
      expect(@results.log).to include("PASS")
    end
  end
end
