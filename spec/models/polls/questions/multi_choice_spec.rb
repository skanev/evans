require 'spec_helper'

module Polls
  module Question
    describe MultiChoice do
      it "renders as a list of check boxes" do
        line = MultiChoice.new name: 'languages', text: 'What do you speak?', options: %w[Ruby Perl]
        line.form_options.should eq as: :check_boxes, label: 'What do you speak?', collection: %w[Ruby Perl]
      end

      it "removes blank items from the value" do
        multi_choice = MultiChoice.new({})

        multi_choice.value(['foo', 'bar']).should eq ['foo', 'bar']
        multi_choice.value(['foo', 'bar', '']).should eq ['foo', 'bar']
      end
    end
  end
end
