require 'spec_helper'

FactoryGirl.factories.each do |factory|
  describe "Factory for: #{factory.name}" do
    it('is valid') { build(factory.name).should be_valid }
  end
end
