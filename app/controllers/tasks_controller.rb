class TasksController < ApplicationController
  before_filter :require_admin, :except => [:index, :show]

  def index
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new params[:task]

    if @task.save
      redirect_to @task, :notice => 'Задачата е създадена успешно'
    else
      render :new
    end
  end

  def show
    @task = Task.find params[:id]
  end
end
