require 'spec_helper'

module Polls
  module Question
    describe MultiChoice do
      it "renders as a list of check boxes" do
        choice = MultiChoice.new name: 'languages', text: 'What do you speak?', options: %w[Ruby Perl]
        choice.form_options[:as].should eq :check_boxes
        choice.form_options[:label].should eq 'What do you speak?'
      end

      it "removes blank items from the value" do
        multi_choice = MultiChoice.new({})

        multi_choice.value(['foo', 'bar']).should eq ['foo', 'bar']
        multi_choice.value(['foo', 'bar', '']).should eq ['foo', 'bar']
      end
    end
  end
end
