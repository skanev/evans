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

  it "does not depend on the CWD" do
    solution = <<-CODE
answer = 42
print("This prints something")
    CODE

    Dir.mktmpdir do |dir|
      Dir.chdir(dir) do
        results = Language::Python.run_tests(@test_case_code, solution)

        expect(results.log).to include("Ran 6 tests")
      end
    end
  end

  it "handles solutions that raise a runtime error" do
    solution = 'import intertools'
    results = Language::Python.run_tests(@test_case_code, solution)

    expect(results.passed_count).to eq 0
    expect(results.failed_count).to eq 0
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
      expect(@results.passed_count).to eq 3
    end

    it "calculates the number of failed tests" do
      expect(@results.failed_count).to eq 3
    end

    it "collects the execution log" do
      expect(@results.log).to include("Ran 6 tests")
      expect(@results.log).to include("FAILED (failures=2, errors=1)")
    end
  end
end
