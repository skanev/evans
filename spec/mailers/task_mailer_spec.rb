require 'spec_helper'

describe TaskMailer do
  describe '#new_task' do
    it_behaves_like 'a user notification mailer',
                    TaskMailer,
                    :new_task,
                    :new_task_for_user,
                    :task_notification
  end

  describe "#new_task_for_user" do
    subject { TaskMailer.new_task_for_user task, user }

    let(:user) { double 'user' }
    let(:time) { Time.now }

    let(:task) { double 'task' }

    before do
      user.stub({
        first_name: 'John',
        email: 'john@doe.com'
      })

      task.stub({
        name: 'Name',
        closes_at: time
      })
    end

    it { should have_subject   'Нова задача - Name' }
    it { should deliver_to     'john@doe.com' }
    it { should have_body_text 'John' }
    it { should have_body_text 'Name' }
    it { should have_body_text task_url(task) }
    it { should have_body_text I18n.l(time) }
  end
end
