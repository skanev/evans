FactoryGirl.define do
  sequence(:email)          { |n| "person-#{n}@example.org" }
  sequence(:faculty_number) { |n| "%05d" % n }
  sequence(:token)          { |n| "%040d" % n }
  sequence(:voucher_code)   { |n| "%08d" % n }
  sequence(:quiz_name)      { |n| "Quiz #{n}" }

  factory :sign_up do
    full_name 'John Doe'
    faculty_number

    factory :assigned_sign_up do
      token
      email
    end
  end

  factory :user do
    email
    faculty_number
    full_name 'John D. Doe'
    name 'John Doe'

    factory :user_with_photo do
      photo { Rack::Test::UploadedFile.new Rails.root.join('spec/fixtures/files/mind_flayer.jpg') }
    end

    factory :admin do
      admin true
    end
  end

  factory :topic do
    title 'Title'
    body 'Body'
    user

    factory(:starred_post) { starred true }
  end

  factory :reply do
    body 'Body'
    topic
    user
  end

  factory :voucher do
    code { generate :voucher_code }
  end

  factory :announcement do
    title 'Title'
    body 'Body'
  end

  factory :task do
    name 'Name'
    description 'Description'
    closes_at 1.week.ago
    checked true
    hidden false
    manually_scored false

    factory :open_task do
      closes_at 1.week.from_now
      checked false
    end

    factory :closed_task

    factory :automatically_scored_task
    factory(:manually_scored_task) { manually_scored true }

    factory(:hidden_task) { hidden true }
  end

  factory :solution do
    user
    task

    factory :solution_with_revisions do
      ignore do
        code 'Code'
        revisions_count 1
      end

      after :create do |solution, evaluator|
        create_list :revision, evaluator.revisions_count, solution: solution, code: evaluator.code
      end
    end

    factory :checked_solution do
      association :task, factory: :closed_task
    end
  end

  factory :revision do
    solution
    code 'Code'
  end

  factory :comment do
    user
    revision
    body 'Body'
  end

  factory :quiz do
    name { generate :quiz_name }
  end

  factory :quiz_result do
    quiz
    user
    correct_answers 0
    points 0
  end

  factory :poll do
    name 'Name'
    blueprint_yaml Hash.new.to_yaml
  end

  factory :poll_answer do
    user
    poll
    answers_yaml Hash.new.to_yaml
  end

  factory :challenge do
    name 'Name'
    description 'Description'
    closes_at 1.day.from_now
    hidden false

    factory :visible_challenge
    factory(:hidden_challenge) { hidden true }
    factory(:open_challenge)   { closes_at 1.day.from_now }
    factory(:closed_challenge) { closes_at 1.day.ago }
  end

  factory :challenge_solution do
    challenge
    user
    code 'Code'
  end

  factory :tip do
    title 'Tip'
    body 'Tip body'
    user
    published_at 1.day.ago
  end

  factory :attribution do
    reason 'Reason'
    link 'http://example.com'
    user
  end
end
