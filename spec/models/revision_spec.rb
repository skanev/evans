require 'spec_helper'

describe Revision do
  it { should validate_presence_of :code }
end
