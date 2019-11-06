require 'spec_helper'

module Polls
  module Question
    describe SingleLine do
      it "renders as a text field" do
        line = SingleLine.new name: 'age', text: 'How old are you?'
        expect(line.form_options[:as]).to eq :string
        expect(line.form_options[:label]).to eq 'How old are you?'
      end

      it "retuns the value as is" do
        expect(SingleLine.new({}).value('foo')).to eq 'foo'
      end
    end
  end
end
