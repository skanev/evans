require 'spec_helper'

describe ChallengeChecker do
  it "runs the test against each solution and updates it" do
    challenge = create :challenge, test_case: 'test case'
    solution  = create :challenge_solution, challenge: challenge, code: 'solution code'

    TestRunner.should_receive(:run).with('test case', 'solution code').and_return([2, 1, 'log'])
    ChallengeSolution.should_receive(:score).with(2, 1).and_return(true)
    ChallengeChecker.new(challenge).run

    solution.reload
    solution.passed_tests.should eq 2
    solution.failed_tests.should eq 1
    solution.correct.should be_true
    solution.log.should eq 'log'
  end
end
