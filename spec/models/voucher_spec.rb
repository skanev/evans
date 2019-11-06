require 'spec_helper'

describe Voucher do
  it { should belong_to(:user) }

  it "can create a batch of vouchers" do
    Voucher.create_codes "1111\n2222 3333"

    expect(Voucher.count).to eq 3
    expect(Voucher.find_by_code('1111')).to be_present
    expect(Voucher.find_by_code('2222')).to be_present
    expect(Voucher.find_by_code('3333')).to be_present
  end

  describe "claiming" do
    let(:user) { create :user }

    context "a free voucher" do
      let(:voucher) { create :voucher }

      it "assigns the user to the voucher" do
        Voucher.claim(user, voucher.code)
        expect(voucher.reload.user).to eq user
      end

      it "updates the voucher's claimed_at time" do
        Timecop.freeze(Time.now) do
          Voucher.claim user, voucher.code
          expect(voucher.reload.claimed_at).to be_within(1.second).of(Time.now)
        end
      end

      it "returns true" do
        expect(Voucher.claim(user, voucher.code)).to be true
      end
    end

    context "a claimed voucher" do
      let(:owner) { create :user }
      let(:voucher) { create :voucher, user: owner }
      let(:impostor) { create :user }

      it "does not change the voucher's owner" do
        Voucher.claim impostor, voucher.code
        expect(voucher.reload.user).to eq owner
      end

      it "returns false" do
        expect(Voucher.claim(impostor, voucher.code)).to be false
      end
    end

    context "an unexisting voucher" do
      it "returns false" do
        user = create :user
        expect(Voucher.claim(user, 'unexisting code')).to be false
      end
    end
  end
end
