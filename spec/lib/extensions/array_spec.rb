require 'spec_helper'

describe Array do
  it "#to_h converts an array of pairs to a hash" do
    [[1, 2], [3, 4]].to_h.should eq(1 => 2, 3 => 4)
    [[1, 2], [1, 3]].to_h.should eq(1 => 3)
    [].to_h.should eq Hash.new
  end
end
