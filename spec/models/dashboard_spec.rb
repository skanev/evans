require 'spec_helper'

describe Dashboard do
  let(:user) { create :user }

  it "presents user's points" do
    user.stub points: 42
    Dashboard.for(user).points.should eq 42
  end

  it "presents user's points with project perfectly done" do
    user.stub points: 22
    Rails.configuration.stub project_score: 20
    Dashboard.for(user).points_with_project.should eq 42
  end

  it "presents user's rank" do
    user.stub rank: 3
    Dashboard.for(user).rank.should eq 3
  end

  it "presents starred posts of user" do
    topic = create :topic, user: user, starred: true
    Dashboard.for(user).stars.should include topic
  end

  it "presents user's attributions" do
    user.stub attributions: ["attribution"]
    Dashboard.for(user).attributions.should include "attribution"
  end

  it "presents number of vouchers the user has earned" do
    voucher = create :voucher
    Voucher.claim(user, voucher.code)
    Dashboard.for(user).vouchers.should eq 1
  end

  it "presents unchecked tasks" do
    task = create :open_task
    Dashboard.for(user).tasks.should include [task.name, nil]
  end

  it "presents tasks without user's solution" do
    task = create :manually_scored_task
    Dashboard.for(user).tasks.should include [task.name, 0]
  end

  it "presents tasks with user's solution" do
    task = create :manually_scored_task
    solution = create :solution, points: 6, task: task, user: user
    Dashboard.for(user).tasks.should include [task.name, 6]
  end

  it "presents unchecked challenges" do
    challenge = create :challenge
    solution = create :challenge_solution, challenge: challenge, user: user
    Dashboard.for(user).challenges.should include [challenge.name, :unchecked]
  end

  it "presents challenges without user's solution" do
    challenge = create :closed_challenge, checked: true
    Dashboard.for(user).challenges.should include [challenge.name, :incorrect]
  end

  it "presents challenges with user's solution" do
    challenge = create :closed_challenge, checked: true
    solution = create :challenge_solution, challenge: challenge, user: user, correct: true
    Dashboard.for(user).challenges.should include [challenge.name, :correct]
  end
end
