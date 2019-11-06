require 'spec_helper'

module Polls
  module Question
    describe MultiChoice do
      it "renders as a list of check boxes" do
        choice = MultiChoice.new name: 'languages', text: 'What do you speak?', options: %w[Ruby Perl]
        expect(choice.form_options[:as]).to eq :check_boxes
        expect(choice.form_options[:label]).to eq 'What do you speak?'
      end

      it "removes blank items from the value" do
        multi_choice = MultiChoice.new({})

        expect(multi_choice.value(['foo', 'bar'])).to eq ['foo', 'bar']
        expect(multi_choice.value(['foo', 'bar', ''])).to eq ['foo', 'bar']
      end
    end
  end
end
