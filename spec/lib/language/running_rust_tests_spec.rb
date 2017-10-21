require 'spec_helper'

describe "Running Rust tests", rust: true do
  before(:all) do
    @test_case_code = <<END.strip
#[test]
fn test_code() {
    assert!(::solution::return_one() == 1i32);
}

#[test]
fn test_code_2() {
    assert!(::solution::return_one() != 2i32);
}

#[test]
#[should_panic]
fn test_expected_failing() {
    assert!(1i32 == 2i32);
}

#[test]
fn test_failing() {
    // Expected failure
    assert!(1i32 == 2i32);
}

#[test]
fn test_2_failing() {
    // Expected failure
    assert!(1i32 == 3i32);
}
END
  end

  def solution
    <<-EOF
      pub fn return_one() -> i32 { 1i32 }

      #[test]
      fn test_ignored_when_counting_successes() {
          assert!(return_one() == 1i32);
      }
    EOF
  end

  it "does not depend on the CWD" do
    Dir.mktmpdir do |dir|
      Dir.chdir(dir) do
        results = Language::Rust.run_tests(@test_case_code, solution)

        results.log.should include("test solution_test::test_failing ... FAILED")
      end
    end
  end

  describe "on successful run" do
    before(:all) do
      @results = Language::Rust.run_tests(@test_case_code, solution)
    end

    it "calculates the number of passed tests" do
      @results.passed_count.should eq 3
    end

    it "calculates the number of failed tests" do
      @results.failed_count.should eq 2
    end

    it "collects the execution log" do
      @results.log.should include("test solution_test::test_code ... ok")
      @results.log.should include("test solution_test::test_code_2 ... ok")
      @results.log.should include("test solution_test::test_expected_failing ... ok")
      @results.log.should include("test solution_test::test_failing ... FAILED")
      @results.log.should include("test solution_test::test_2_failing ... FAILED")

      @results.log.should include("test solution::test_ignored_when_counting_successes ... ok")
    end
  end
end
