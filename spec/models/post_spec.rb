require 'spec_helper'

describe Post do
  it { should validate_presence_of :body }
  it { should validate_presence_of :user_id }
end
