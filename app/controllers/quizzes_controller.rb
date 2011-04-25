class QuizzesController < ApplicationController
  def show
    @quiz = Quiz.find params[:id]
    @results = @quiz.results
  end
end
