shared_examples_for 'a user notification mailer' do |model, mailer, subject|
  let(:model_instance) { double model }

  describe "#new_#{model}" do
    let(:mailer_delay) { double "#{mailer}.delay" }

    before do
      mailer.stub(:delay) { mailer_delay }
    end

    it 'sends multiple emails' do
      first_user  = create :user, "#{model}_notification" => true
      second_user = create :user, "#{model}_notification" => true

      mailer_delay.should_receive("new_#{model}_for_user").with(model_instance, first_user)
      mailer_delay.should_receive("new_#{model}_for_user").with(model_instance, second_user)

      mailer.public_send "new_#{model}", model_instance
    end

    it 'does not send emails to unsubscribed users' do
      create :user, "#{model}_notification" => false
      user = create :user, "#{model}_notification" => true

      mailer_delay.should_receive("new_#{model}_for_user").with(model_instance, user)

      mailer.public_send "new_#{model}", model_instance
    end
  end

  describe "#new_#{model}_for_user" do
    subject { mailer.public_send "new_#{model}_for_user", model_instance, user }

    let(:user) { double 'user' }
    let(:time) { Time.now }

    before do
      user.stub({
        first_name: 'John',
        email: 'john@doe.com'
      })

      model_instance.stub({
        name: 'Name',
        closes_at: time
      })
    end

    it { should have_subject   subject % 'Name' }
    it { should deliver_to     'john@doe.com' }
    it { should have_body_text 'John' }
    it { should have_body_text 'Name' }
    it { should have_body_text public_send "#{model}_url", model_instance }
    it { should have_body_text I18n.l(time) }
  end
end
