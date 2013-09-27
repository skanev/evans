require 'spec_helper'

describe 'Running Clojure tests', clojure: true do
  before :all do
    @test_case_code = <<END.strip
(deftest sample-test
  (is (= true true) "first pass")
  (is (nil? (prn "Just messing up")) "second, printing pass")
  (is (= true false) "first fail")
  (is (= answer 42) "second pass")
  (is (= nil (throw (Exception. "Some text"))) "fail with error")
  (is (= 1 2) "second fail"))
END
  end

  it "handles solutions that raise a runtime error" do
    solution = "(require 'intertools)"
    results = Language::Clojure.run_tests(@test_case_code, solution)

    results.passed_count.should eq 0
    results.failed_count.should eq 0
  end

  describe "on successful run" do
    before(:all) do
      solution = <<-EOF
(def answer 42)
(print "Printing something")
      EOF
      @results = Language::Clojure.run_tests(@test_case_code, solution)
    end

    it "calculates the number of passed tests" do
      @results.passed_count.should eq 3
    end

    it "calculates the number of failed tests" do
      @results.failed_count.should eq 3
    end

    it "collects the execution log" do
      @results.log.should include("Ran 1 tests containing 6 assertions")
      @results.log.should include("2 failures, 1 errors.")
    end
  end
end
