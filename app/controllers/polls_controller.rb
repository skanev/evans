# encoding: utf-8
class PollsController < ApplicationController
  before_filter :require_admin, except: :index

  def index
    @polls = Poll.all
  end

  def new
    @poll = Poll.new
  end

  def create
    @poll = Poll.new params[:poll]

    if @poll.save
      redirect_to polls_path, notice: 'Анкетата е добавена успешно'
    else
      render :new
    end
  end

  def show
    @poll = Poll.find params[:id]

    @data = {}
    questions = []
    @poll.blueprint.each do |question|
      next unless question['type'].in? ['single-choice', 'multi-choice']
      questions << question
    end

    @poll.answers.each do |submission|
      submission_answers = submission.answers

      questions.each do |question|
        name    = question['name']
        answers = Array(submission_answers[name])

        @data[name] ||= {}
        @data[name]['type'] ||= (question['type'] == 'single-choice' ? 'pie' : 'column')
        @data[name]['title'] ||= question['text']
        @data[name]['data'] ||= {}

        answers.each do |answer|
          @data[name]['data'][answer] ||= 0
          @data[name]['data'][answer] += 1
        end
      end
    end

    #@data = questions
  end

  def edit
    @poll = Poll.find params[:id]
  end

  def update
    @poll = Poll.find params[:id]

    if @poll.update_attributes params[:poll]
      redirect_to polls_path, notice: 'Анкетата е обновена успешно'
    else
      render :edit
    end
  end
end
