require 'spec_helper'

describe Attribution do
  it "only allows urls for its link" do
    expect(build(:attribution, link: 'non-url')).not_to be_valid
    expect(build(:attribution, link: 'http://example.com/')).to be_valid
  end
end
