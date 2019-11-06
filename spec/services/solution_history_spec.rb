require 'spec_helper'

describe SolutionHistory do
  let(:solution) { create :solution }

  subject(:history) { SolutionHistory.new(solution) }

  it 'knows the solution revisions' do
    allow(solution).to receive(:revisions).and_return(:revisions)

    expect(history.revisions).to eq :revisions
  end

  it 'knows which is the last revision' do
    allow(solution).to receive(:revisions).and_return([:a, :b])

    expect(history.last_revision).to eq :b
  end

  it 'knows the revision count' do
    allow(solution).to receive(:revisions).and_return([:a, :b, :c])

    expect(history.revisions_count).to eq 3
  end

  it 'knows the comment count' do
    allow(solution).to receive(:comments).and_return([:a, :b])

    expect(history.comments_count).to eq 2
  end

  context 'with revisions and comments' do
    before do
      allow(Language).to receive(:language).and_return('ruby')

      @first_revision  = create :revision, solution: solution, code: 'first'
      @second_revision = create :revision, solution: solution, code: 'second'

      @non_inline_comment = create :comment, revision: @first_revision

      @first_comment  = create :inline_comment, revision: @first_revision,  line_number: 0
      @second_comment = create :inline_comment, revision: @second_revision, line_number: 0
    end

    it 'uses CommentHistory to combine inline comments' do
      comment_history = double combined_comments: :combined_comments

      allow(FormattedCode::CommentHistory).to receive(:new).and_return(comment_history)

      expect(comment_history).to receive(:add_version).with('first',  {0 => [@first_comment]})
      expect(comment_history).to receive(:add_version).with('second', {0 => [@second_comment]})

      expect(history.combined_comments).to eq :combined_comments
    end

    it 'can create formatted code instances for the solution' do
      allow(history).to receive(:combined_comments).and_return('comments')

      expect(FormattedCode::Code).to receive(:new).with('second', 'ruby', 'comments').and_return(:code)

      expect(history.formatted_code).to eq :code
    end

    it 'can create formatted diffs for the first revision' do
      expect(FormattedCode::Diff).to receive(:new)
        .with('', 'first', 'ruby', {0 => [@first_comment]})
        .and_return(:diff)

      expect(history.formatted_diff_for(@first_revision)).to eq :diff
    end

    it 'can create formatted diffs for revisions' do
      expect(FormattedCode::Diff).to receive(:new)
        .with('first', 'second', 'ruby', {0 => [@second_comment]})
        .and_return(:diff)

      expect(history.formatted_diff_for(@second_revision)).to eq :diff
    end

    it 'can return non-inline comments for revision' do
      expect(history.non_inline_comments_for(@first_revision)).to  eq [@non_inline_comment]
      expect(history.non_inline_comments_for(@second_revision)).to eq []
    end
  end
end
