require 'spec_helper'

describe ChallengesHelper do
  describe "#challenge_solution_status" do
    let(:challenge) { double }
    let(:solution) { double challenge: challenge }

    before do
      allow(helper).to receive(:admin?)
      allow(challenge).to receive(:checked?)
      allow(solution).to receive(:log).and_return('')
      allow(solution).to receive(:correct?).and_return('')
    end

    context "when unchecked" do
      before do
        allow(challenge).to receive(:checked?).and_return(false)
      end

      it "shows it as unchecked to students" do
        expect(helper.challenge_solution_status(solution)).to eq :unchecked
      end

      it "shows it as unchecked to admins if tests have not been run" do
        allow(helper).to receive(:admin?).and_return(true)
        allow(solution).to receive(:log).and_return('')
        expect(helper.challenge_solution_status(solution)).to eq :unchecked
      end

      it "shows it as is to admins if tests have been run" do
        allow(helper).to receive(:admin?).and_return(true)
        allow(solution).to receive(:log).and_return('foo')
        allow(solution).to receive(:correct?).and_return(true)
        expect(helper.challenge_solution_status(solution)).to eq :correct
      end
    end

    context "when checked" do
      before do
        allow(challenge).to receive(:checked?).and_return(true)
      end

      it "shows if it is correct" do
        allow(solution).to receive(:correct?).and_return(true)
        expect(helper.challenge_solution_status(solution)).to eq :correct
      end

      it "shows if it is incorrect" do
        allow(solution).to receive(:correct?).and_return(false)
        expect(helper.challenge_solution_status(solution)).to eq :incorrect
      end
    end
  end

  describe "#challenge_solution_status_text" do
     it "translates the status of the solution" do
       allow(helper).to receive(:challenge_solution_status).and_return(:correct)
       expect(helper.challenge_solution_status_text(double)).to eq 'Коректно'
     end
  end
end
