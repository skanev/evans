FactoryGirl.define do
  sequence(:email) { |n| "person-#{n}@example.org" }
  sequence(:faculty_number) { |n| "%05d" % n }
  sequence(:token) { |n| "%040d" % n }
  sequence(:voucher_code) { |n| "%08d" % n }

  factory :sign_up do
    full_name 'John Doe'
    faculty_number
  end

  factory :assigned_sign_up, :parent => :sign_up do
    token
    email
  end

  factory :user do
    email
    faculty_number
    full_name 'John Doe'
  end

  factory :admin, :parent => :user do
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

  factory :voucher do
    code { Factory.next(:voucher_code) }
  end
end
