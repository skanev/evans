require 'spec_helper'

describe AdminConstraint do
  let(:request) { double env: {'warden' => warden} }
  let(:warden) { double }
  let(:user) { double }

  before do
    warden.stub :authenticate?
    warden.stub user: user
    user.stub :admin?
  end

  it "does not match unauthenticated users" do
    warden.stub authenticate?: false
    AdminConstraint.new.matches?(request).should be_false
  end

  it "does not match non-admins" do
    warden.stub authenticate?: true
    user.stub admin?: false
    AdminConstraint.new.matches?(request).should be_false
  end

  it "matches admins" do
    warden.stub authenticate?: true
    user.stub admin?: true
    AdminConstraint.new.matches?(request).should be_true
  end
end
