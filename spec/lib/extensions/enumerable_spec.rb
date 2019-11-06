require 'spec_helper'

describe Enumerable do
  it "#map_hash maps pairs to a hash" do
    expect([].map_hash { |n| [1, 2] }).to eq({})
    expect([3, 4].map_hash { |n| [n * 2, n ** 2] }).to eq(6 => 9, 8 => 16)
    expect([-3, 3].map_hash { |n| [n.abs, n] }).to eq(3 => 3)
  end
end
