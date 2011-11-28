require 'spec_helper'

describe "Point mechanics" do
  it "student has no points initially" do
    FactoryGirl.create(:user).points.should == 0
  end

  it "student gets a point if they have a photo" do
    user = FactoryGirl.create :user_with_photo
    user.points.should == 1
  end

  it "student gets a point for each claimed voucher" do
    user = FactoryGirl.create :user
    2.times { FactoryGirl.create :voucher, :user => user }

    user.points.should == 2
  end

  it "student gets points from each solution" do
    solution = FactoryGirl.create :checked_solution, :passed_tests => 1
    user = solution.user

    user.points.should == solution.max_points
  end

  it "student gets points for each starred post" do
    user = Factory(:user)
    Factory(:topic, :user => user, :starred => true)
    Factory(:reply, :user => user, :starred => true)

    user.points.should == 2
  end

  it "student gets points from quizzes" do
    user = FactoryGirl.create :user
    FactoryGirl.create :quiz_result, :user => user, :points => 10

    user.points.should == 10
  end
end
