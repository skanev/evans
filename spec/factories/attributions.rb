# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :attribution do
    reason "MyString"
    user_id 1
  end
end
