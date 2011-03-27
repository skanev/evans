namespace :task do
  desc "Checks the solutions of a task"
  task :check, [:task_id] => :environment do |_, args|
    task = Task.find args.task_id
    checker = TaskChecker.new task

    checker.on_each_solution do |solution|
      puts "User ##{solution.user_id}: Passed: #{solution.passed_tests} Failed: #{solution.failed_tests}"
    end

    checker.run
  end
end
