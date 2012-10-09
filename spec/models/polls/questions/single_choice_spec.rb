require 'spec_helper'

module Polls
  module Question
    describe SingleChoice do
      it "renders as radio buttons" do
        line = SingleChoice.new name: 'languages', text: 'What do you speak best?', options: %w[Ruby Perl]
        line.form_options.should eq as: :radio_buttons, label: 'What do you speak best?', collection: %w[Ruby Perl]
      end

      it "returns the value as is" do
        SingleChoice.new({}).value('foo').should eq 'foo'
      end
    end
  end
end
