require 'spec_helper'
require 'fakes/factories'

describe "Fake factories" do
  it "can construct all the fake factories" do
    fake_factories = FactoryGirl.factories.map(&:name).grep(/\Afake_/)

    fake_factories.each do |factory_name|
      create factory_name
    end
  end
end
