require 'spec_helper'

module Polls
  module Question
    describe SingleChoice do
      it "renders as radio buttons" do
        choice = SingleChoice.new name: 'languages', text: 'What do you speak best?', options: %w[Ruby Perl]
        choice.form_options[:as].should eq :radio_buttons
        choice.form_options[:label].should eq 'What do you speak best?'
      end

      it "returns the value as is" do
        SingleChoice.new({}).value('foo').should eq 'foo'
      end
    end
  end
end
