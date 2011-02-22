# Step helpers, confusingly named after something awesome
module AnotherWorld
  def last_sent_email
    ActionMailer::Base.deliveries.last.body.to_s
  end

  def backdoor_login(user)
    visit "/backdoor-login?email=#{CGI.escape(user.email)}"
  end

  def file_fixture(file_name)
    Rails.root.join('spec/fixtures/files', file_name)
  end
end

World(AnotherWorld)
