require 'spec_helper'

describe User do
  it "can shorten the name of a user" do
    expect(User.shorten_name('Петър Иванов')).to eq 'Петър Иванов'
    expect(User.shorten_name('Петър Петров Иванов')).to eq 'Петър Иванов'
    expect(User.shorten_name('Петър Петров Петров Иванов')).to eq 'Петър Иванов'
  end

  it "can tell the first name of the user" do
    expect(build(:user, name: 'Петър').first_name).to eq 'Петър'
    expect(build(:user, name: 'Петър Петров').first_name).to eq 'Петър'
    expect(build(:user, name: 'Петър Петров Иванов').first_name).to eq 'Петър'
  end

  it "has 0 points if admin" do
    expect(create(:admin).points).to eq 0
  end

  it "has rank 0 if admin" do
    expect(create(:admin).rank).to eq 0
  end

  describe "sorting" do
    it "sorts by creation time, older users first" do
      second = create :user, created_at: 2.days.ago
      third  = create :user, created_at: 1.day.ago
      first  = create :user, created_at: 3.days.ago

      expect(User.sorted).to eq [first, second, third]
    end

    it "puts users with photos before users without photos" do
      second = create :user
      first  = create :user_with_photo

      expect(User.sorted).to eq [first, second]
    end
  end

  describe "pagination" do
    before do
      expect(User).to receive(:paginate).with(page: 'foo', per_page: 20)
    end

    it "delegates to paginate with 20 users per page" do
      User.at_page('foo')
    end

    it "works with scopes" do
      User.students.at_page('foo')
    end
  end
end
