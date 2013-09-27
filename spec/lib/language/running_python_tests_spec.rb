require 'spec_helper'

describe 'Running Python tests', python: true do
  before :all do
    @test_case_code = <<END.strip
import unittest
import solution

class SampleTest(unittest.TestCase):
    def test_first_pass(self):
        self.assertEqual(True, True)

    def test_printing_passing_test(self):
        print("Just messing up with you")

    def test_first_fail(self):
        self.assertEqual(True, False)

    def test_second_pass(self):
        self.assertEqual(solution.answer, 42)

    def test_fails_win_error(self):
        raise Exception("An error!")

    def test_second_fail(self):
        self.assertEqual(1, 2)
END
  end

  it "handles solutions that raise a runtime error" do
    solution = 'import intertools'
    results = Language::Python.run_tests(@test_case_code, solution)

    results.passed_count.should eq 0
    results.failed_count.should eq 0
  end

  describe "on successful run" do
    before :all do
      solution = <<-EOF
answer = 42
print("This prints something")
      EOF
      @results = Language::Python.run_tests(@test_case_code, solution)
    end

    it "calculates the number of passed tests" do
      @results.passed_count.should eq 3
    end

    it "calculates the number of failed tests" do
      @results.failed_count.should eq 3
    end

    it "collects the execution log" do
      @results.log.should include("Ran 6 tests")
      @results.log.should include("FAILED (failures=2, errors=1)")
    end
  end
end
