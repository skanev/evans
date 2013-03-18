require 'spec_helper'

describe TaskChecker do
  it "runs the test against each solution and updates it" do
    task         = create :task, test_case: 'test case', max_points: 6
    solution     = create :solution_with_revisions, task: task, code: 'solution code'
    test_results = double passed_count: 2, failed_count: 1, log: 'log'

    Language.should_receive(:run_tests).with('test case', 'solution code').and_return(test_results)
    Solution.should_receive(:calculate_points).with(2, 1, 6).and_return(3)
    TaskChecker.new(task).run

    solution.reload
    solution.passed_tests.should eq 2
    solution.failed_tests.should eq 1
    solution.points.should eq 3
    solution.log.should eq 'log'
  end
end
