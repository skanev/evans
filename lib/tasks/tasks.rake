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

  namespace :dump do
    desc "Dumps all the solutions in tmp/solutions"
    task :solutions => :environment do
      Task.all.each do |task|
        directory = Rails.root.join("tmp/solutions/#{task.id}")
        task_name = task.name

        FileUtils.mkdir_p directory

        task.solutions.each do |solution|
          user_name      = solution.user.name
          faculty_number = solution.user.faculty_number
          code           = solution.code
          log            = solution.log
          file           = directory.join("#{faculty_number}.py")

          puts "Dumping #{file}"

          open(file.to_s, 'w') do |output|
            output.puts "# #{user_name}"
            output.puts "# #{faculty_number}"
            output.puts "# http://#{Rails.application.config.site_domain}/tasks/#{task.id}/solutions/#{solution.id}"
            output.puts ""
            output.puts code.gsub(/\t/, '    ').gsub(/\r/, '').strip
            output.puts ""
            output.puts ""
            output.puts "__END__"
            output.puts log
          end
        end
      end
    end

    desc "Runs the test agains all solutions in tmp/solutions/task_id"
    task :check, [:task_id] => :environment do |_, args|
      task_id   = args.task_id
      directory = Rails.root.join("tmp/solutions/#{task_id}")
      spec_path = directory.join('spec.py')

      raise "There should be a spec in #{spec_path.relative_path_from(Rails.root)}" unless spec_path.exist?

      directory.each_child do |solution_path|
        next if solution_path == spec_path

        puts "Processing #{solution_path.relative_path_from(Rails.root)}..."

        log_with_json     = `python3.2 python/homework.py #{solution_path} #{spec_path}`
        log               = log_with_json.split("\nLOG:\n")[1]
        solution_with_log = solution_path.read.gsub(/__END__.*\Z/m, '') + "__END__\n#{log}"

        open(solution_path, 'w') { |file| file.write solution_with_log }
      end
    end
  end
end
