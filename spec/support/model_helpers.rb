module Support
  module ModelHelpers
    def expect_email_delivery(mailer, method, *args)
      mail = double("#{mailer.name}.#{method}'s mail")

      mailer.should_receive(method).with(*args).and_return(mail)
      mail.should_receive(:deliver)
    end
  end
end
