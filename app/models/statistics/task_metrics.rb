# encoding: utf-8
module Statistics
  class TaskMetrics
    WEEK_DAYS = %w[Неделя Понеделник Вторник Сряда Четвъртък Петък Събота]

    def initialize(task)
      @task = task

      calculate
    end

    def passed_tests
      0.upto(@passed_tests.keys.max).map { |n| [n, @passed_tests[n]] }
    end

    def submission_days
      start_date = @task.created_at.to_date
      end_date   = @task.closes_at.to_date

      (start_date..end_date).map { |date| [WEEK_DAYS[date.wday], @submission_date[date]] }
    end

    private

    def calculate
      @tests_count     = 0
      @passed_tests    = Hash.new(0)
      @submission_date = Hash.new(0)

      @task.solutions.each do |solution|
        passed         = solution.passed_tests
        tests          = solution.passed_tests + solution.failed_tests
        date_submitted = solution.created_at.to_date

        @passed_tests[passed] += 1
        @tests_count = [tests, @tests_count].max
        @submission_date[date_submitted] += 1
      end
    end
  end
end
