require 'spec_helper'

describe PointsBreakdown do
  let(:user) { create :user }
  let(:breakdown) { PointsBreakdown.find user.id }

  it "knows the id of the user" do
    breakdown.id.should eq user.id
  end

  it "knows the name of the user" do
    breakdown.name.should eq user.name
  end

  it "knows how many points a user has from vouchers" do
    create :voucher, user: user
    breakdown.vouchers.should eq 1
  end

  it "knows how many points a user has from vouchers" do
    create :starred_post, user: user
    breakdown.stars.should eq 1
  end

  it "knows the points in each task" do
    create :solution, user: user, points: 1
    create :solution, user: user, points: 2

    breakdown.tasks_breakdown.should eq [1, 2]
  end

  it "knows the points in each quiz" do
    create :quiz_result, user: user, points: 1
    create :quiz_result, user: user, points: 2

    breakdown.quizzes_breakdown.should eq [1, 2]
  end

  it "knows the total points of the user" do
    create :voucher, user: user
    create :starred_post, user: user
    create :solution, user: user, points: 1
    create :quiz_result, user: user, points: 1

    breakdown.total.should eq 4
  end

  it "knows the rank of the user" do
    first  = create :user
    second = create :user
    third  = create :user

    create :solution, user: first,  points: 2
    create :solution, user: second, points: 2
    create :solution, user: third,  points: 1

    PointsBreakdown.find(first.id).rank.should eq 1
    PointsBreakdown.find(second.id).rank.should eq 1
    PointsBreakdown.find(third.id).rank.should eq 3
  end

  it "has reasonable defaults when the user has no points" do
    breakdown.vouchers.should eq 0
    breakdown.stars.should eq 0
    breakdown.tasks_breakdown.should eq []
    breakdown.quizzes_breakdown.should eq []
  end

  it "assigns 0 points to tasks without solutions" do
    create :task
    breakdown.tasks_breakdown.should eq [0]
  end

  it "does not assign negative points to tasks" do
    create :solution, user: user, points: 1, adjustment: -2
    breakdown.tasks_breakdown.should eq [0]
  end

  it "assigns 0 points to quizzes without results" do
    create :quiz
    breakdown.quizzes_breakdown.should eq [0]
  end

  it "raises an error the user does not exists" do
    expect { PointsBreakdown.find 0 }.to raise_error 'Cannot find user with id = 0'
  end
end
