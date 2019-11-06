require 'spec_helper'

describe TaskChecker do
  it "runs the task checker on the task" do
    task_checker = double 'task checker'
    expect(Task).to receive(:find).with(42).and_return('task')
    expect(TaskChecker).to receive(:new).with('task').and_return(task_checker)
    expect(task_checker).to receive(:run)

    TaskCheckWorker.perform_async 42
    TaskCheckWorker.drain
  end
end
