class TasksController < ApplicationController
  before_action :require_admin, except: %w(index show guide)

  def index
    @tasks = if admin?
      Task.in_chronological_order
    else
      Task.visible
    end
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new params[:task]

    if @task.save
      redirect_to @task, notice: 'Задачата е създадена успешно'
    else
      render :new
    end
  end

  def show
    @task = Task.find params[:id]
    @current_user_solution = Solution.for current_user, @task if current_user

    deny_access if @task.hidden? and not admin?
  end

  def edit
    @task = Task.find params[:id]
  end

  def update
    @task = Task.find params[:id]

    if @task.update_attributes params[:task]
      redirect_to @task, notice: 'Задачата е обновена успешно'
    else
      render :edit
    end
  end

  def guide
    render "tasks/guides/#{Language.language}"
  end
end
