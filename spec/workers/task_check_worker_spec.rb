require 'spec_helper'

describe TaskChecker do
  it "runs the task checker on the task" do
    task_checker = double 'task checker'
    Task.should_receive(:find).with(42).and_return('task')
    TaskChecker.should_receive(:new).with('task').and_return(task_checker)
    task_checker.should_receive(:run)

    TaskCheckWorker.perform_async 42
    TaskCheckWorker.drain
  end
end
