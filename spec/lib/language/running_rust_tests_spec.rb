require 'spec_helper'

describe "Running Rust tests", rust: true do
  before(:all) do
    @test_case_code = <<END.strip
mod solution;

#[cfg(test)]
mod solution_test {
    #[test]
    fn basic_test() {
        assert!(1i32 < 2i32);
    }

    #[test]
    #[should_panic]
    fn expected_failing_test() {
        assert!(1i32 == 2i32);
    }

    #[test]
    fn failing_test() {
        // Expected failure
        assert!(1i32 == 2i32);
    }
}
END
  end

  it "does not depend on the CWD" do
    solution = "#[allow(dead_code)]\nfn main() {}"

    Dir.mktmpdir do |dir|
      Dir.chdir(dir) do
        results = Language::Rust.run_tests(@test_case_code, solution)

        results.log.should include("test solution_test::failing_test ... FAILED")
      end
    end
  end

  describe "on successful run" do
    before(:all) do
      solution = "#[allow(dead_code)]\nfn main() {}"
      @results = Language::Rust.run_tests(@test_case_code, solution)
    end

    it "calculates the number of passed tests" do
      @results.passed_count.should eq 2
    end

    it "calculates the number of failed tests" do
      @results.failed_count.should eq 1
    end

    it "collects the execution log" do
      @results.log.should include("test solution_test::basic_test ... ok")
      @results.log.should include("test solution_test::expected_failing_test ... ok")
      @results.log.should include("test solution_test::failing_test ... FAILED")
    end
  end
end
