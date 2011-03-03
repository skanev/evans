require 'spec_helper'

describe "Point mechanics" do
  it "student has no points initially" do
    User.make.points.should == 0
  end

  it "student gets a point if they have a photo" do
    user = Factory(:user_with_photo)
    user.points.should == 1
  end

  it "student gents a point for each claimed voucher" do
    user = User.make
    2.times { Voucher.make :user => user }

    user.points.should == 2
  end
end
