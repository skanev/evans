require 'spec_helper'

describe TaskMailer do
  let(:task) { double 'task' }

  describe '#new_task' do
    let(:mailer_delay) { double 'TaskMailer.delay' }

    before do
      TaskMailer.stub(:delay) { mailer_delay }
    end

    it 'sends multiple emails' do
      users = [
        create(:user, task_notification: true),
        create(:user, task_notification: true),
      ]

      users.each do |user|
        mailer_delay.should_receive(:new_task_for_user).with(task, user)
      end

      TaskMailer.new_task task
    end

    it 'does not send emails to unsubscribed users' do
      create(:user, task_notification: false)
      users = [
        create(:user, task_notification: true),
        create(:user, task_notification: true),
      ]

      users.each do |user|
        mailer_delay.should_receive(:new_task_for_user).with(task, user)
      end

      TaskMailer.new_task task
    end
  end

  describe '#new_task_for_user' do
    subject { TaskMailer.new_task_for_user(task, user) }

    let(:user) { double 'user' }
    let(:time) { Time.now }

    before do
      user.stub first_name: 'John',
                email:      'john@doe.com'

      task.stub name:      'Task name',
                closes_at: time
    end

    it { should have_subject   'Нова задача - Task name' }
    it { should deliver_to     'john@doe.com' }
    it { should have_body_text 'John' }
    it { should have_body_text 'Task name' }
    it { should have_body_text task_url(task) }
    it { should have_body_text time.strftime('%d.%m.%Y %H:%M') }
  end
end
