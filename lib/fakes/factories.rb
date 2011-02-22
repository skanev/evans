FactoryGirl.define do
  sequence(:fake_email) { |n| "person-#{n}@example.org" }
  sequence(:fake_faculty_number) { |n| "%05d" % (10000 + n) }
  sequence(:fake_token) { |n| "%040d" % n }

  factory :fake_sign_up, :class => :sign_up do
    full_name { Faker.name }
    faculty_number
  end

  factory :fake_assigned_sign_up, :parent => :fake_sign_up do
    token
    email
  end

  factory :fake_user, :class => :user do
    email
    faculty_number
    full_name { Faker::Name.name }
    photo { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/fakes', %w[1.jpg 2.jpg 3.jpg 4.jpg].rand)) }
  end

  factory :fake_admin, :parent => :fake_user do
    admin true
  end

  factory :fake_topic, :class => :topic do
    user { User.all.rand }
    title { Faker::Lorem.sentence }
    body { Faker::Lorem.paragraphs.join("\n\n") }
  end

  factory :fake_reply, :class => :reply do
    topic { Topic.all.rand }
    user { User.all.rand }
    body { Faker::Lorem.paragraphs.join("\n\n") }
  end
end
