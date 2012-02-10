# encoding: utf-8
class TasksController < ApplicationController
  before_filter :require_admin, :except => [:index, :show, :guide]

  def index
    @tasks = Task.all :order => 'created_at ASC'

    respond_to do |format|
      format.html
      format.rss { response.headers['Content-Type'] = 'application/rss+xml; charset=utf-8' }
    end
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

  def edit
    @task = Task.find params[:id]
  end

  def update
    @task = Task.find params[:id]

    if @task.update_attributes params[:task]
      redirect_to @task, :notice => 'Задачата е обновена успешно'
    else
      render :edit
    end
  end
end
