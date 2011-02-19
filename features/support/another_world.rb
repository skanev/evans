# Step helpers, confusingly named after something awesome
module AnotherWorld
  def last_sent_email
    ActionMailer::Base.deliveries.last.body.to_s
  end
end

World(AnotherWorld)
