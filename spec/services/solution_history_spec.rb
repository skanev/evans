require 'spec_helper'

describe SolutionHistory do
  let(:solution) { create :solution }

  subject(:history) { SolutionHistory.new(solution) }

  it 'knows the solution revisions' do
    solution.stub revisions: :revisions

    history.revisions.should eq :revisions
  end

  it 'knows which is the last revision' do
    solution.stub revisions: [:a, :b]

    history.last_revision.should eq :b
  end

  it 'knows the revision count' do
    solution.stub revisions: [:a, :b, :c]

    history.revisions_count.should eq 3
  end

  it 'knows the comment count' do
    solution.stub comments: [:a, :b]

    history.comments_count.should eq 2
  end

  context 'with revisions and comments' do
    before do
      Language.stub language: 'ruby'

      @first_revision  = create :revision, solution: solution, code: 'first'
      @second_revision = create :revision, solution: solution, code: 'second'

      @non_inline_comment = create :comment, revision: @first_revision

      @first_comment  = create :inline_comment, revision: @first_revision,  line_number: 0
      @second_comment = create :inline_comment, revision: @second_revision, line_number: 0
    end

    it 'uses CommentHistory to combine inline comments' do
      comment_history = double combined_comments: :combined_comments

      FormattedCode::CommentHistory.stub new: comment_history

      comment_history.should_receive(:add_version).with('first',  {0 => [@first_comment]})
      comment_history.should_receive(:add_version).with('second', {0 => [@second_comment]})

      history.combined_comments.should eq :combined_comments
    end

    it 'can create formatted code instances for the solution' do
      history.stub combined_comments: 'comments'

      FormattedCode::Code.should_receive(:new).with('second', 'ruby', 'comments').and_return(:code)

      history.formatted_code.should eq :code
    end

    it 'can create formatted diffs for the first revision' do
      FormattedCode::Diff.should_receive(:new)
        .with('', 'first', 'ruby', {0 => [@first_comment]})
        .and_return(:diff)

      history.formatted_diff_for(@first_revision).should eq :diff
    end

    it 'can create formatted diffs for revisions' do
      FormattedCode::Diff.should_receive(:new)
        .with('first', 'second', 'ruby', {0 => [@second_comment]})
        .and_return(:diff)

      history.formatted_diff_for(@second_revision).should eq :diff
    end

    it 'can return non-inline comments for revision' do
      history.non_inline_comments_for(@first_revision).should  eq [@non_inline_comment]
      history.non_inline_comments_for(@second_revision).should eq []
    end
  end
end
