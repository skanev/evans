FactoryGirl.define do
  sequence(:email) { |n| "person-#{n}@example.org" }
  sequence(:faculty_number) { |n| "%05d" % n }
  sequence(:token) { |n| "%040d" % n }
  sequence(:voucher_code) { |n| "%08d" % n }
  sequence(:quiz_name) { |n| "Quiz #{n}" }

  factory :sign_up do
    full_name 'John Doe'
    faculty_number
  end

  factory :assigned_sign_up, parent: :sign_up do
    token
    email
  end

  factory :user do
    email
    faculty_number
    full_name 'John D. Doe'
    name 'John Doe'
  end

  factory :user_with_photo, parent: :user do
    photo { Rack::Test::UploadedFile.new Rails.root.join('spec/fixtures/files/mind_flayer.jpg') }
  end

  factory :admin, parent: :user do
    admin true
  end

  factory :topic do
    title 'Title'
    body 'Body'
    user
  end

  factory :reply do
    body 'Body'
    topic
    user
  end

  factory :starred_post, parent: :topic do
    starred true
  end

  factory :voucher do
    code { FactoryGirl.generate(:voucher_code) }
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

    factory :closed_task
    factory :open_task do
      closes_at 1.week.from_now
      checked false
    end
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

  factory :checked_solution, parent: :solution do
    association :task, factory: :closed_task
  end

  factory :quiz do
    name { FactoryGirl.generate(:quiz_name) }
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
end
