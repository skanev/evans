require 'spec_helper'

module Polls
  module Question
    describe Line do
      it "renders as a text field" do
        line = SingleLine.new name: 'age', text: 'How old are you?'
        line.form_options.should eq as: :string, label: 'How old are you?'
      end

      it "retuns the value as is" do
        SingleLine.new({}).value('foo').should eq 'foo'
      end
    end
  end
end
