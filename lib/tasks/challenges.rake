namespace :challenge do
  desc "Checks the solutions of a task"
  task :check, [:challenge_id] => :environment do |_, args|
    challenge = Challenge.find args.challenge_id
    checker = ChallengeChecker.new challenge

    checker.on_each_solution do |solution|
      puts "User ##{solution.user_id}: Passed: #{solution.passed_tests} Failed: #{solution.failed_tests}"
    end

    checker.run
  end
end
