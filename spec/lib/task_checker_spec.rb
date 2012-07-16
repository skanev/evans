require 'spec_helper'

describe TaskChecker do
  it "runs the test against each solution and updates it" do
    task = create :task, :test_case => 'test case'
    solution = create :solution, :task => task, :code => 'solution code'

    TestRunner.should_receive(:run).with('test case', 'solution code').and_return([2, 1, 'log'])
    TaskChecker.new(task).run

    solution.reload
    solution.passed_tests.should == 2
    solution.failed_tests.should == 1
    solution.log.should == 'log'
  end
end
