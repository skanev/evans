require 'spec_helper'

describe TaskChecker do
  it "runs the test against each solution and updates it" do
    task         = create :task, test_case: 'test case', max_points: 6
    solution     = create :solution_with_revisions, task: task, code: 'solution code'
    test_results = double passed_count: 2, failed_count: 1, log: 'log'

    expect(Language).to receive(:run_tests).with('test case', 'solution code').and_return(test_results)
    expect(Solution).to receive(:calculate_points).with(2, 1, 6).and_return(3)
    TaskChecker.new(task).run

    solution.reload
    expect(solution.passed_tests).to eq 2
    expect(solution.failed_tests).to eq 1
    expect(solution.points).to eq 3
    expect(solution.log).to eq 'log'
  end
end
