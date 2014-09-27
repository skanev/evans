shared_examples_for 'a user notification mailer' do |mailer, method, email_method, user_filter|
  let(:mailer_delay)   { double "#{mailer}.delay" }
  let(:model_instance) { double 'model' }

  before do
    mailer.stub(:delay) { mailer_delay }
  end

  it 'sends multiple emails' do
    first_user  = create :user, user_filter => true
    second_user = create :user, user_filter => true

    mailer_delay.should_receive(email_method).with(model_instance, first_user)
    mailer_delay.should_receive(email_method).with(model_instance, second_user)

    mailer.public_send method, model_instance
  end

  it 'does not send emails to unsubscribed users' do
    create :user, user_filter => false
    user = create :user, user_filter => true

    mailer_delay.should_receive(email_method).with(model_instance, user)

    mailer.public_send method, model_instance
  end
end
