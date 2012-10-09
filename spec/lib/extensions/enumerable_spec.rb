require 'spec_helper'

describe Enumerable do
  it "#map_hash maps pairs to a hash" do
    [].map_hash { |n| [1, 2] }.should eq({})
    [3, 4].map_hash { |n| [n * 2, n ** 2] }.should eq(6 => 9, 8 => 16)
    [-3, 3].map_hash { |n| [n.abs, n] }.should eq(3 => 3)
  end
end
