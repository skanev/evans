# encoding: utf-8
require 'spec_helper'

describe SolutionMailer do
  describe "new comment" do
    subject { SolutionMailer.new_comment(comment) }

    let(:comment) { double 'comment' }
    let(:solution) { build_stubbed :solution }

    before do
      comment.stub solution: solution
      comment.stub task_name: 'Задача'
      comment.stub_chain :solution, :user, :email => 'solution.author@example.org'
      comment.stub body: 'тяло на коментара'
    end

    it { should have_subject 'Нов коментар на Задача' }
    it { should deliver_to 'solution.author@example.org' }
    it { should have_body_text 'Задача' }
    it { should have_body_text 'тяло на коментара' }
    it { should have_body_text solution_url(solution) }
  end
end
