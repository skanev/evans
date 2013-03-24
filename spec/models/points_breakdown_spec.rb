require 'spec_helper'

describe PointsBreakdown do
  let(:user) { create :user }
  let(:breakdown) { PointsBreakdown.find user.id }

  it "knows the id of the user" do
    breakdown.id.should eq user.id
  end

  it "knows the facutly number of the user" do
    breakdown.faculty_number.should eq user.faculty_number
  end

  it "knows the name of the user" do
    breakdown.name.should eq user.name
  end

  it "knows how many points a user has from vouchers" do
    create :voucher, user: user
    breakdown.vouchers.should eq 1
  end

  it "knows how many points a user has from attributions" do
    create :attribution, user: user
    breakdown.attributions.should eq 1
  end

  it "knows how many points a user has from stars" do
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
    create :attribution, user: user
    create :solution, user: user, points: 1
    create :quiz_result, user: user, points: 1

    breakdown.total.should eq 5
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

  it "assigns 0 points to tasks without solutions" do
    create :task
    breakdown.tasks_breakdown.should eq [0]
  end

  it "ignores tasks that are not checked" do
    create :solution, user: user, points: 1, task: create(:closed_task)
    create :solution, user: user, points: 2, task: create(:open_task)
    create :solution, user: user, points: 3, task: create(:closed_task)

    breakdown.tasks_breakdown.should eq [1, 3]
  end

  it "does not assign negative points to tasks" do
    create :solution, user: user, points: 1, adjustment: -2
    breakdown.tasks_breakdown.should eq [0]
  end

  it "assigns 0 points to quizzes without results" do
    create :quiz
    breakdown.quizzes_breakdown.should eq [0]
  end

  it "assigns points for all correct challenges" do
    challenge = create :challenge, checked: true
    create :challenge_solution, challenge: challenge, user: user, correct: true
    breakdown.challenges.should eq 1
  end

  it "does not assign points to incorrect challenge solutions" do
    challenge = create :challenge, checked: true
    create :challenge_solution, challenge: challenge, user: user, correct: false
    breakdown.challenges.should eq 0
  end

  it "does not assign points to correct solutions of unchecked challenges" do
    challenge = create :challenge, checked: false
    create :challenge_solution, challenge: challenge, user: user, correct: true
    breakdown.challenges.should eq 0
  end

  it "assigns a point to users with photos" do
    user = create :user_with_photo
    PointsBreakdown.find(user.id).photo.should eq 1
  end

  it "does not assign photo points to users without photos" do
    breakdown.photo.should eq 0
  end

  it "has reasonable defaults when the user has no points" do
    breakdown.vouchers.should eq 0
    breakdown.stars.should eq 0
    breakdown.tasks_breakdown.should eq []
    breakdown.quizzes_breakdown.should eq []
  end

  it "raises an error the user does not exists" do
    expect { PointsBreakdown.find 0 }.to raise_error 'Cannot find user with id = 0'
  end

  it "can retrieve breakdowns for all users" do
    first  = create :user
    second = create :user
    create :voucher, user: first

    breakdowns = PointsBreakdown.all

    breakdowns.map(&:id).should eq [first.id, second.id]
  end

  it "does not retrieve breakdowns for admins" do
    user  = create :user
    admin = create :admin

    user_ids = PointsBreakdown.all.map(&:id)

    user_ids.should include user.id
    user_ids.should_not include admin.id
  end

  it "can tell how many users have ranking" do
    create :user
    create :admin

    PointsBreakdown.count.should eq 1
  end

  describe "(medals)" do
    it "assigns a gold medal to the first place" do
      PointsBreakdown.new(rank: 1).medal.should eq :gold
    end

    it "assigns a silver medal to the second and third place" do
      PointsBreakdown.new(rank: 2).medal.should eq :silver
      PointsBreakdown.new(rank: 3).medal.should eq :silver
    end

    it "assigns a bronze medal to places four to ten" do
      PointsBreakdown.new(rank: 4).medal.should eq :bronze
      PointsBreakdown.new(rank: 5).medal.should eq :bronze
      PointsBreakdown.new(rank: 9).medal.should eq :bronze
      PointsBreakdown.new(rank: 10).medal.should eq :bronze
    end

    it "does not assign a medal to places eleventh or higher" do
      PointsBreakdown.new(rank: 11).medal.should be_nil
      PointsBreakdown.new(rank: 19).medal.should be_nil
    end
  end
end
