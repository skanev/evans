require 'spec_helper'

describe TestRunner do
  let(:test_case_code) do
    <<END.strip
import homework

class HomeworkTest(homework.Test):
    def test_success_1(self): self.assert_(True)
    def test_success_3(self): print("Just to mess up with you")
    def test_failure_1(self): self.assert_(False)
    def test_success_2(self): self.assertEquals(self.solution.answer, 42)
    def test_failure_2(self): self.assertEquals(1, 2)
    def test_errored_1(self): raise RuntimeError

if __name__ == '__main__':
    HomeworkTest.main()
END
  end

  it "handles solutions that raise a runtime error" do
    solution = 'import intertools'
    runner = TestRunner.new(test_case_code, solution)

    runner.run

    runner.passed_count.should == 0
    runner.failures_count.should == 0
  end

  describe "on successful run" do
    before(:all) do
      solution = 'answer = 42; print("Another print")'
      @runner = TestRunner.new(test_case_code, solution)

      @runner.run
    end

    it "calculates the number of passed tests" do
      @runner.passed_count.should == 3
    end

    it "calculates the number of failed tests" do
      @runner.failures_count.should == 3
    end

    it "collects the execution log" do
      @runner.log.should include("FAILED (failures=2, errors=1)")
    end
  end
end
