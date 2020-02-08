require 'spec_helper'

describe ChallengeChecker do
  it "runs the test against each solution and updates it" do
    challenge    = create :challenge, test_case: 'test case'
    solution     = create :challenge_solution, challenge: challenge, code: 'solution code'
    test_results = double passed_count: 2, failed_count: 1, log: 'log'

    expect(Language).to receive(:run_tests).with('test case', 'solution code').and_return(test_results)
    expect(ChallengeSolution).to receive(:correct?).with(2, 1).and_return(true)
    ChallengeChecker.new(challenge).run

    solution.reload
    expect(solution.passed_tests).to eq 2
    expect(solution.failed_tests).to eq 1
    expect(solution.correct).to be true
    expect(solution.log).to eq 'log'
  end
end
