require 'spec_helper'

describe QuizzesController do
  describe "GET show" do
    let(:quiz) { double }

    before do
      allow(Quiz).to receive(:find).and_return(quiz)
      allow(quiz).to receive(:results)
    end

    it "assigns the quiz to @quiz" do
      expect(Quiz).to receive(:find).with('42')
      get :show, id: '42'
      expect(assigns(:quiz)).to eq quiz
    end

    it "assigns the results to @results" do
      allow(quiz).to receive(:results).and_return('results')
      get :show, id: '42'
      expect(assigns(:results)).to eq 'results'
    end
  end
end
