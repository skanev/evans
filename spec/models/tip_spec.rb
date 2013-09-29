require 'spec_helper'

describe Tip do
  let(:user)       { create :user }
  let(:admin_user) { create :admin }

  context "with no user" do
    it "lists published tips" do
      Timecop.freeze do
        first  = create :tip, published_at: 1.day.ago
        second = create :tip, published_at: nil
        third  = create :tip, published_at: 1.day.from_now

        Tip.list_as(nil).should =~ [first]
      end
    end
  end

  context "as administrator" do
    def build_tip(attributes = {})
      Tip.build_as(admin_user, attributes_for(:tip).merge(attributes))
    end

    it "lists all tips" do
      Timecop.freeze do
        first  = create :tip, published_at: 1.day.ago
        second = create :tip, published_at: nil
        third  = create :tip, published_at: 1.day.from_now

        Tip.list_as(admin_user).should =~ [first, second, third]
      end
    end

    it "suggests a default value for published_at if there are no tips" do
      Timecop.freeze do
        build_tip.published_at.should be_within(1.second).of(Time.now)
      end
    end

    it "suggests a default value for published_at if there are tips" do
      Timecop.freeze do
        first = create :tip, published_at: 2.days.ago
        build_tip.published_at.should be_within(1.second).of(1.day.ago)
      end
    end
  end

  context "as normal user" do
    def build_tip(attributes = {})
      Tip.build_as(user, attributes_for(:tip).merge(attributes))
    end

    it "lists published and creator's tips" do
      Timecop.freeze do
        first  = create :tip, published_at: 1.day.ago
        second = create :tip, published_at: nil
        third  = create :tip, published_at: 1.day.from_now
        fourth = create :tip, published_at: nil, user: user

        Tip.list_as(user).should =~ [first, fourth]
      end
    end

    it "ensures that published_at is nil upon building" do
      Timecop.freeze do
        build_tip.published_at.should be_nil
        build_tip(published_at: Time.zone.now).published_at.should be_nil
      end
    end

    it "ensures that published_at is not changed upon updating" do
      Timecop.freeze do
        tip = create :tip, title: 'Original', published_at: 2.days.ago
        tip.update_as(user, title: 'Changed', published_at: 1.day.ago)
        tip.reload

        tip.title.should eq 'Changed'
        tip.published_at.should be_within(1.second).of(2.days.ago)
      end
    end
  end
end
