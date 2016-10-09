require 'spec_helper'

describe Notification do
  it "can be marked as read" do
    notification = create(:notification)
    notification.mark_as_read
    notification.read.should eq true
  end
end
