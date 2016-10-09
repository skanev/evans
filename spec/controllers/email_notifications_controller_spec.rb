require 'spec_helper'

shared_examples_for 'an email sender' do |action, model, mailer|
  log_in_as :admin

  it 'denies access to non-admins' do
    current_user.stub admin?: false
    post action, id: '1'
    response.should deny_access
  end

  it 'sends emails' do
    challenge = create model, hidden: false, id: 1

    mailer.should_receive(action).with(challenge)
    post action, id: '1'
  end

  it "does not schedule the emails if the #{model} is hidden" do
    hidden_challenge = create model, hidden: true, id: 1

    mailer.should_not_receive(action)
    post action, id: '1'
  end

  it "redirects to the #{model}" do
    create model, hidden: false, id: 1

    post action, id: '1'
    controller.should redirect_to send("#{model}_path", '1')
  end
end

describe EmailNotificationsController do
  describe "POST new_challenge" do
    it_behaves_like 'an email sender', :new_challenge, :challenge, ChallengeMailer
  end

  describe "POST new_task" do
    it_behaves_like 'an email sender', :new_task, :task, TaskMailer
  end
end
