require 'spec_helper'

describe SolutionMailer do
  describe "new comment" do
    subject { SolutionMailer.new_comment(comment) }

    let(:comment) { double 'comment' }
    let(:solution) { build_stubbed :solution }

    before do
      allow(comment).to receive(:solution).and_return(solution)
      allow(comment).to receive(:task_name).and_return('Task name')
      allow(comment).to receive_message_chain :solution, :user, email: 'solution.author@example.org'
      allow(comment).to receive(:body).and_return('Comment body')
      allow(comment).to receive(:user_name).and_return('Comment author')
    end

    it { should have_subject 'Нов коментар на Task name' }
    it { should deliver_to 'solution.author@example.org' }
    it { should have_body_text 'Task name' }
    it { should have_body_text 'Comment author' }
    it { should have_body_text solution_url(solution) }
    it { should have_body_text 'Comment body' }
  end
end
