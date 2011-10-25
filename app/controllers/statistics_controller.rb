class StatisticsController < ApplicationController
  def show
    @task = Task.find params[:task_id]
    @task_metrics = Statistics::TaskMetrics.new @task
  end
end
