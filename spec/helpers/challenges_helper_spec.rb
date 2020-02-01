require 'spec_helper'

describe ChallengesHelper do
  describe "#challenge_solution_status" do
    let(:challenge) { double }
    let(:solution) { double challenge: challenge }

    before do
      helper.stub :admin?
      challenge.stub :checked?
      solution.stub log: ''
      solution.stub correct?: ''
    end

    context "when unchecked" do
      before do
        challenge.stub checked?: false
      end

      it "shows it as unchecked to students" do
        expect(helper.challenge_solution_status(solution)).to eq :unchecked
      end

      it "shows it as unchecked to admins if tests have not been run" do
        helper.stub admin?: true
        solution.stub log: ''
        expect(helper.challenge_solution_status(solution)).to eq :unchecked
      end

      it "shows it as is to admins if tests have been run" do
        helper.stub admin?: true
        solution.stub log: 'foo'
        solution.stub correct?: true
        expect(helper.challenge_solution_status(solution)).to eq :correct
      end
    end

    context "when checked" do
      before do
        challenge.stub checked?: true
      end

      it "shows if it is correct" do
        solution.stub correct?: true
        expect(helper.challenge_solution_status(solution)).to eq :correct
      end

      it "shows if it is incorrect" do
        solution.stub correct?: false
        expect(helper.challenge_solution_status(solution)).to eq :incorrect
      end
    end
  end

  describe "#challenge_solution_status_text" do
     it "translates the status of the solution" do
       helper.stub challenge_solution_status: :correct
       expect(helper.challenge_solution_status_text(double)).to eq 'Коректно'
     end
  end
end
