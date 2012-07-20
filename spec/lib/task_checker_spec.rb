require 'spec_helper'

describe TaskChecker do
  it "runs the test against each solution and updates it" do
    task = create :task, test_case: 'test case', max_points: 6
    solution = create :solution, task: task, code: 'solution code'

    TestRunner.should_receive(:run).with('test case', 'solution code').and_return([2, 1, 'log'])
    Solution.should_receive(:calculate_points).with(2, 1, 6).and_return(3)
    TaskChecker.new(task).run

    solution.reload
    solution.passed_tests.should eq 2
    solution.failed_tests.should eq 1
    solution.points.should eq 3
    solution.log.should eq 'log'
  end
end
