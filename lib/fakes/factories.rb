FactoryGirl.define do
  sequence(:fake_email) { |n| "person-#{n}@example.org" }
  sequence(:fake_faculty_number) { |n| "%05d" % (10000 + n) }
  sequence(:fake_token) { |n| "%040d" % n }

  factory :fake_sign_up, class: :sign_up do
    full_name { Faker.name }
    faculty_number
  end

  factory :fake_assigned_sign_up, parent: :fake_sign_up do
    token
    email
  end

  factory :fake_user, class: :user do
    email
    faculty_number
    name { Faker::Name.name }
    full_name { Faker::Name.name }
    photo { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/fakes', %w[1.jpg 2.jpg 3.jpg 4.jpg].sample)) } unless Rails.env.test?
  end

  factory :fake_admin, parent: :fake_user do
    admin true
  end

  factory :fake_topic, class: :topic do
    user { User.all.sample }
    title { Faker::Lorem.sentence }
    body { Faker::Lorem.paragraphs.join("\n\n") }
  end

  factory :fake_reply, class: :reply do
    topic { Topic.all.sample }
    user { User.all.sample }
    body { Faker::Lorem.paragraphs.join("\n\n") }
  end

  factory :fake_announcement, class: :announcement do
    title { Faker::Lorem.sentence }
    body { Faker::Lorem.paragraphs.join("\n\n") }
  end

  factory :fake_open_task, class: :task do
    name { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraphs.join("\n\n") }
    closes_at 1.year.from_now
    hidden false
  end

  factory :fake_closed_task, class: :task do
    name { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraphs.join("\n\n") }
    closes_at 1.year.ago
    hidden false
    checked true
  end

  factory :fake_checked_solution, class: :solution do
    association :user, factory: :fake_user
    add_attribute(:task) { Task.where('closes_at < ?', Time.now).sample }
    passed_tests { rand(10) }
    failed_tests { rand(10) }
    log 'Log'

    after :create do |solution|
      create :fake_revision, solution: solution
    end
  end

  factory :fake_non_checked_solution, class: :solution do
    association :user, factory: :fake_user
    add_attribute(:task) { Task.where('closes_at > ?', Time.now).sample }

    after :create do |solution|
      create :fake_revision, solution: solution
    end
  end

  factory :fake_revision, class: :revision do
    association :solution, factory: :fake_checked_solution
    code 'print("larodi")'
  end

  factory :fake_quiz, class: :quiz do
    name { "Quiz #{rand(100)}" }
  end

  factory :fake_quiz_result, class: :quiz_result do
    association :user, factory: :fake_user
    quiz { Quiz.all.sample }
    correct_answers { rand(51) }
    points { rand(31) }
  end
end
