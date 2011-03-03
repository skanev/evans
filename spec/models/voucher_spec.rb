require 'spec_helper'

describe Voucher do
  it "can create a batch of vouchers" do
    Voucher.create_codes "1111\n2222 3333"

    Voucher.count.should == 3
    Voucher.find_by_code('1111').should be_present
    Voucher.find_by_code('2222').should be_present
    Voucher.find_by_code('3333').should be_present
  end
end
