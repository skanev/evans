# Step helpers, confusingly named after something awesome
module AnotherWorld
  def last_sent_email
    ActionMailer::Base.deliveries.last.body.to_s
  end

  def backdoor_login(user)
    visit "/backdoor-login?email=#{CGI.escape(user.email)}"
  end
end

World(AnotherWorld)
