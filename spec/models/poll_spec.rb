require 'spec_helper'

describe Poll do
  it "converts the blueprint to YAML and back" do
    hash = {'foo' => 1, 'bar' => 2}
    poll = build :poll

    poll.blueprint = hash
    expect(poll.blueprint_yaml).to eq hash.to_yaml
    poll.save!

    poll.reload
    expect(poll.blueprint).to eq hash
    expect(poll.blueprint_yaml).to eq hash.to_yaml
  end
end
