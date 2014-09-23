require 'spec_helper'

describe TaskObserver do
  describe '#after_create' do
    it "notifies users via email" do
      task = build :task, hidden: false, checked: false
      TaskMailer.should_receive(:new_task).with(task)
      task.save!
    end

    it "does not notify users if the task is hidden" do
      task = build :task, hidden: true, checked: false
      TaskMailer.should_not_receive(:new_task)
      task.save!
    end

    it "does not notify users if the task is checked" do
      task = build :task, hidden: false, checked: true
      TaskMailer.should_not_receive(:new_task)
      task.save!
    end
  end

  describe '#after_update' do
    it "notifies users if #hidden changes from true to false" do
      task = create :task, hidden: true, checked: false
      task.hidden = false

      TaskMailer.should_receive(:new_task).with(task)

      task.save!
    end

    it "does not notify users if the hidden attribute does not change" do
      task = create :task, hidden: false, checked: false
      task.name = 'test'

      TaskMailer.should_not_receive(:new_task)

      task.save!
    end

    it "does not notify users if the task is checked" do
      task = create :task, hidden: true, checked: false
      task.hidden  = false
      task.checked = true

      TaskMailer.should_not_receive(:new_task)

      task.save!
    end
  end
end
