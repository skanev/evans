require 'spec_helper'

describe SolutionMailer do
  describe "new comment" do
    subject { SolutionMailer.new_comment(comment) }

    let(:comment) { double 'comment' }
    let(:solution) { build_stubbed :solution }

    before do
      comment.stub solution: solution
      comment.stub task_name: 'Task name'
      comment.stub_chain :solution, :user, email: 'solution.author@example.org'
      comment.stub body: 'Comment body'
      comment.stub user_name: 'Comment author'
    end

    it { should have_subject 'Нов коментар на Task name' }
    it { should deliver_to 'solution.author@example.org' }
    it { should have_body_text 'Task name' }
    it { should have_body_text 'Comment author' }
    it { should have_body_text solution_url(solution) }
    it { should have_body_text 'Comment body' }
  end
end
