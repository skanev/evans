require 'spec_helper'

describe AdminConstraint do
  let(:request) { double env: {'warden' => warden} }
  let(:warden) { double }
  let(:user) { double }

  before do
    allow(warden).to receive(:authenticate?)
    allow(warden).to receive(:user).and_return(user)
    allow(user).to receive(:admin?)
  end

  it "does not match unauthenticated users" do
    allow(warden).to receive(:authenticate?).and_return(false)
    expect(AdminConstraint.new.matches?(request)).to be false
  end

  it "does not match non-admins" do
    allow(warden).to receive(:authenticate?).and_return(true)
    allow(user).to receive(:admin?).and_return(false)
    expect(AdminConstraint.new.matches?(request)).to be false
  end

  it "matches admins" do
    allow(warden).to receive(:authenticate?).and_return(true)
    allow(user).to receive(:admin?).and_return(true)
    expect(AdminConstraint.new.matches?(request)).to be true
  end
end
