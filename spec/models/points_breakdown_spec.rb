require 'spec_helper'

describe PointsBreakdown do
  let(:user) { create :user }
  let(:breakdown) { PointsBreakdown.find user.id }

  it "knows the id of the user" do
    expect(breakdown.id).to eq user.id
  end

  it "knows the facutly number of the user" do
    expect(breakdown.faculty_number).to eq user.faculty_number
  end

  it "knows the name of the user" do
    expect(breakdown.name).to eq user.name
  end

  it "knows how many points a user has from vouchers" do
    create :voucher, user: user
    expect(breakdown.vouchers).to eq 1
  end

  it "knows how many points a user has from attributions" do
    create :attribution, user: user
    expect(breakdown.attributions).to eq 1
  end

  it "knows how many points a user has from stars" do
    create :starred_post, user: user
    expect(breakdown.stars).to eq 1
  end

  it "knows the points in each task" do
    create :solution, user: user, points: 1
    create :solution, user: user, points: 2

    expect(breakdown.tasks_breakdown).to eq [1, 2]
  end

  it "knows the points in each quiz" do
    create :quiz_result, user: user, points: 1
    create :quiz_result, user: user, points: 2

    expect(breakdown.quizzes_breakdown).to eq [1, 2]
  end

  it "knows the total points of the user" do
    create :voucher, user: user
    create :starred_post, user: user
    create :attribution, user: user
    create :solution, user: user, points: 1
    create :quiz_result, user: user, points: 1

    expect(breakdown.total).to eq 5
  end

  it "knows the rank of the user" do
    first  = create :user
    second = create :user
    third  = create :user

    create :solution, user: first,  points: 2
    create :solution, user: second, points: 2
    create :solution, user: third,  points: 1

    expect(PointsBreakdown.find(first.id).rank).to eq 1
    expect(PointsBreakdown.find(second.id).rank).to eq 1
    expect(PointsBreakdown.find(third.id).rank).to eq 3
  end

  it "assigns 0 points to tasks without solutions" do
    create :task
    expect(breakdown.tasks_breakdown).to eq [0]
  end

  it "ignores tasks that are not checked" do
    create :solution, user: user, points: 1, task: create(:closed_task)
    create :solution, user: user, points: 2, task: create(:open_task)
    create :solution, user: user, points: 3, task: create(:closed_task)

    expect(breakdown.tasks_breakdown).to eq [1, 3]
  end

  it "does not assign negative points to tasks" do
    create :solution, user: user, points: 1, adjustment: -2
    expect(breakdown.tasks_breakdown).to eq [0]
  end

  it "assigns 0 points to quizzes without results" do
    create :quiz
    expect(breakdown.quizzes_breakdown).to eq [0]
  end

  it "assigns points for all correct challenges" do
    first_challenge = create :challenge, checked: true
    create :challenge_solution, challenge: first_challenge, user: user, correct: true

    second_challenge = create :challenge, checked: true, points: 5
    create :challenge_solution, challenge: second_challenge, user: user, correct: true

    expect(breakdown.challenges).to eq 6
  end

  it "does not assign points to incorrect challenge solutions" do
    challenge = create :challenge, checked: true
    create :challenge_solution, challenge: challenge, user: user, correct: false
    expect(breakdown.challenges).to eq 0
  end

  it "does not assign points to correct solutions of unchecked challenges" do
    challenge = create :challenge, checked: false
    create :challenge_solution, challenge: challenge, user: user, correct: true
    expect(breakdown.challenges).to eq 0
  end

  it "assigns a point to users with photos" do
    user = create :user_with_photo
    expect(PointsBreakdown.find(user.id).photo).to eq 1
  end

  it "does not assign photo points to users without photos" do
    expect(breakdown.photo).to eq 0
  end

  it "has reasonable defaults when the user has no points" do
    expect(breakdown.vouchers).to eq 0
    expect(breakdown.stars).to eq 0
    expect(breakdown.tasks_breakdown).to eq []
    expect(breakdown.quizzes_breakdown).to eq []
  end

  it "raises an error the user does not exists" do
    expect { PointsBreakdown.find 0 }.to raise_error 'Cannot find user with id = 0'
  end

  it "can retrieve breakdowns for all users" do
    first  = create :user
    second = create :user
    create :voucher, user: first

    breakdowns = PointsBreakdown.all

    expect(breakdowns.map(&:id)).to eq [first.id, second.id]
  end

  it "does not retrieve breakdowns for admins" do
    user  = create :user
    admin = create :admin

    user_ids = PointsBreakdown.all.map(&:id)

    expect(user_ids).to include user.id
    expect(user_ids).to_not include admin.id
  end

  it "can tell how many users have ranking" do
    create :user
    create :admin

    expect(PointsBreakdown.count).to eq 1
  end

  describe "(medals)" do
    it "assigns a gold medal to the first place" do
      expect(PointsBreakdown.new(rank: 1).medal).to eq :gold
    end

    it "assigns a silver medal to the second and third place" do
      expect(PointsBreakdown.new(rank: 2).medal).to eq :silver
      expect(PointsBreakdown.new(rank: 3).medal).to eq :silver
    end

    it "assigns a bronze medal to places four to ten" do
      expect(PointsBreakdown.new(rank: 4).medal).to eq :bronze
      expect(PointsBreakdown.new(rank: 5).medal).to eq :bronze
      expect(PointsBreakdown.new(rank: 9).medal).to eq :bronze
      expect(PointsBreakdown.new(rank: 10).medal).to eq :bronze
    end

    it "does not assign a medal to places eleventh or higher" do
      expect(PointsBreakdown.new(rank: 11).medal).to be_nil
      expect(PointsBreakdown.new(rank: 19).medal).to be_nil
    end
  end
end
