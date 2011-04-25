require 'spec_helper'

describe Quiz do
  it { should validate_presence_of(:name) }
  it { should have_many(:results) }
end
