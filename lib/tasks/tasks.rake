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

  desc "Dumps all the solutions in tmp/solutions"
  task :dump => :environment do
    Task.all.each do |task|
      directory = Rails.root.join("tmp/solutions/#{task.id}")
      task_name = task.name

      FileUtils.mkdir_p directory

      task.solutions.each do |solution|
        user_name      = solution.user.name
        faculty_number = solution.user.faculty_number
        code           = solution.code
        log            = solution.log
        file           = directory.join("#{faculty_number}.rb")

        puts "Dumping #{file}"

        open(file.to_s, 'w') do |output|
          output.puts "# #{user_name}"
          output.puts "# #{faculty_number}"
          output.puts "# http://fmi.ruby.bg/tasks/#{task.id}/solutions/#{solution.id}"
          output.puts ""
          output.puts code.strip
          output.puts ""
          output.puts ""
          output.puts "__END__"
          output.puts log
        end
      end
    end
  end
end
