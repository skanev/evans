require 'spec_helper'

describe Poll do
  it "converts the blueprint to YAML and back" do
    hash = {'foo' => 1, 'bar' => 2}
    poll = build :poll

    poll.blueprint = hash
    poll.blueprint_yaml.should eq hash.to_yaml
    poll.save!

    poll.reload
    poll.blueprint.should eq hash
    poll.blueprint_yaml.should eq hash.to_yaml
  end
end
