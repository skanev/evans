require 'spec_helper'

describe Voucher do
  it { should belong_to(:user) }

  it "can create a batch of vouchers" do
    Voucher.create_codes "1111\n2222 3333"

    Voucher.count.should == 3
    Voucher.find_by_code('1111').should be_present
    Voucher.find_by_code('2222').should be_present
    Voucher.find_by_code('3333').should be_present
  end

  describe "claiming" do
    let(:user) { User.make }

    context "a free voucher" do
      let(:voucher) { Voucher.make }

      it "assigns the user to the voucher" do
        Voucher.claim(user, voucher.code)
        voucher.reload.user.should == user
      end

      it "returns true" do
        Voucher.claim(user, voucher.code).should be_true
      end
    end

    context "a claimed voucher" do
      let(:owner) { User.make }
      let(:voucher) { Voucher.make :user => owner }
      let(:impostor) { User.make }

      it "does not change the voucher's owner" do
        Voucher.claim impostor, voucher.code
        voucher.reload.user.should == owner
      end

      it "returns false" do
        Voucher.claim(impostor, voucher.code).should be_false
      end
    end

    context "an unexisting voucher" do
      it "returns false" do
        Voucher.claim(User.make, 'unexisting code').should be_false
      end
    end
  end
end
