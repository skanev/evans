namespace :quiz do
  desc "Interactively adds results to a quiz"
  task :results, [:quiz_id] => :environment do |_, args|
    quiz = Quiz.find args.quiz_id
    puts "Adding results for quiz ##{quiz.id}: #{quiz.name}"
    while true
        user = read_user
        next if user.nil?
        correct_answers = read_correct_answers
        next if reject? user, correct_answers
        QuizResult.create! quiz_id: quiz.id, user_id: user.id, correct_answers: correct_answers, points: correct_answers
		puts "OK"
    end
  end

  def read_user
    print "FN> "
    faculty_number = STDIN.gets.chomp
    user = User.find_by_faculty_number faculty_number
    if user.nil?
        puts "A user with faculty number #{faculty_number} doesn't exist."
    end
    user
  end

  def read_correct_answers
    points = 0
    while points.zero?
        print "ANSWERS> "
        points = STDIN.gets.chomp.to_i
    end
    points
  end

  def reject? user, correct_answers
      print "Add #{user.faculty_number} #{user.name} #{correct_answers} correct answers? Press y to confirm: "
      "y" != STDIN.gets.chomp
  end
end
