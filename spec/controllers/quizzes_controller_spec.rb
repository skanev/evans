require 'spec_helper'

describe QuizzesController do
  describe "GET show" do
    let(:quiz) { double }

    before do
      Quiz.stub find: quiz
      quiz.stub :results
    end

    it "assigns the quiz to @quiz" do
      Quiz.should_receive(:find).with('42')
      get :show, id: '42'
      assigns(:quiz).should eq quiz
    end

    it "assigns the results to @results" do
      quiz.stub results: 'results'
      get :show, id: '42'
      assigns(:results).should eq 'results'
    end
  end
end
