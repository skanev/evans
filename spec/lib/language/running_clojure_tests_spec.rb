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

    expect(results.passed_count).to eq 0
    expect(results.failed_count).to eq 0
  end

  it "does not depend on the CWD" do
    solution = <<-CODE
(def answer 42)
(print "Printing something")
    CODE

    Dir.mktmpdir do |dir|
      Dir.chdir(dir) do
        results = Language::Clojure.run_tests(@test_case_code, solution)

        expect(results.log).to include("Ran 1 tests containing 6 assertions")
      end
    end
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
      expect(@results.passed_count).to eq 3
    end

    it "calculates the number of failed tests" do
      expect(@results.failed_count).to eq 3
    end

    it "collects the execution log" do
      expect(@results.log).to include("Ran 1 tests containing 6 assertions")
      expect(@results.log).to include("2 failures, 1 errors.")
    end
  end
end
