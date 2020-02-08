module Support
  module ModelHelpers
    def expect_email_delivery(mailer, method, *args)
      mail = double("#{mailer.name}.#{method}'s mail")

      expect(mailer).to receive(method).with(*args).and_return(mail)
      expect(mail).to receive(:deliver_now)
    end
  end
end
