require 'spec_helper'

describe QuizzesController do
  describe "GET show" do
    let(:quiz) { double }

    before do
      Quiz.stub find: quiz
      quiz.stub :results
    end

    it "assigns the quiz to @quiz" do
      expect(Quiz).to receive(:find).with('42')
      get :show, id: '42'
      expect(assigns(:quiz)).to eq quiz
    end

    it "assigns the results to @results" do
      quiz.stub results: 'results'
      get :show, id: '42'
      expect(assigns(:results)).to eq 'results'
    end
  end
end
