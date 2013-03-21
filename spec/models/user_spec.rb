# encoding: utf-8
require 'spec_helper'

describe User do
  it { should have_many(:solutions) }
  it { should_not allow_mass_assignment_of(:faculty_number) }
  it { should_not allow_mass_assignment_of(:full_name) }
  it { should_not allow_mass_assignment_of(:email) }
  it { should_not allow_mass_assignment_of(:admin) }

  it "can shorten the name of a user" do
    User.shorten_name('Петър Иванов').should eq 'Петър Иванов'
    User.shorten_name('Петър Петров Иванов').should eq 'Петър Иванов'
    User.shorten_name('Петър Петров Петров Иванов').should eq 'Петър Иванов'
  end

  it "can tell the first name of the user" do
    build(:user, name: 'Петър').first_name.should eq 'Петър'
    build(:user, name: 'Петър Петров').first_name.should eq 'Петър'
    build(:user, name: 'Петър Петров Иванов').first_name.should eq 'Петър'
  end

  it "has 0 points if admin" do
    create(:admin).points.should eq 0
  end

  describe "pagination" do
    it "sorts by creation time, older users first" do
      second = create :user, created_at: 2.days.ago
      third  = create :user, created_at: 1.day.ago
      first  = create :user, created_at: 3.days.ago

      User.page(1).should eq [first, second, third]
    end

    it "puts users with photos before users without photos" do
      second = create :user
      first  = create :user_with_photo

      User.page(1).should eq [first, second]
    end
  end
end
