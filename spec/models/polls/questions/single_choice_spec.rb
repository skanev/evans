require 'spec_helper'

module Polls
  module Question
    describe SingleChoice do
      it "renders as radio buttons" do
        choice = SingleChoice.new name: 'languages', text: 'What do you speak best?', options: %w[Ruby Perl]
        expect(choice.form_options[:as]).to eq :radio_buttons
        expect(choice.form_options[:label]).to eq 'What do you speak best?'
      end

      it "returns the value as is" do
        expect(SingleChoice.new({}).value('foo')).to eq 'foo'
      end
    end
  end
end
