require 'spec_helper'
require './lib/extensions/array'

describe Array do
  it "#to_h converts an array of pairs to a hash" do
    expect([[1, 2], [3, 4]].to_h).to eq(1 => 2, 3 => 4)
    expect([[1, 2], [1, 3]].to_h).to eq(1 => 3)
    expect([].to_h).to eq Hash.new
  end
end
