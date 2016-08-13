require 'spec_helper'

describe Solutions::Revision do
  describe 'delegates' do
    subject { Solutions::Revision.new(nil, build(:revision)) }

    it { is_expected.to delegate_method(:id).to(:model) }
    it { is_expected.to delegate_method(:created_at).to(:model) }
    it { is_expected.to delegate_method(:code).to(:model) }
  end

  describe '#first_revision?' do
    it 'is true when there is no parent revision' do
      expect(Solutions::Revision.new(nil, :revision)).to be_first_revision
    end

    it 'is false when a parent revision exists' do
      expect(Solutions::Revision.new(:parent, :revision)).to_not be_first_revision
    end
  end

  describe '#revisions' do
    it 'yields all revisions in chronological order' do
      first_revision  = Solutions::Revision.new(nil, :revision_one)
      second_revision = Solutions::Revision.new(first_revision, :revision_two)
      third_revision  = Solutions::Revision.new(second_revision, :revision_three)

      expect(third_revision.revisions.to_a).to eq [first_revision, second_revision, third_revision]
    end
  end

  describe '#formatted_code' do
    it 'returns an instance of FormattedCode::Code' do
      revision = Solutions::Revision.new(nil, double(:revision, code: 'puts 1'))

      allow(Language).to receive(:language).and_return 'ruby'
      allow(revision).to receive(:inline_comments).and_return(:comments)

      expect(FormattedCode::Code).to receive(:new).with('puts 1', 'ruby', :comments).and_return :result

      expect(revision.formatted_code).to eq :result
    end
  end

  describe '#formatted_diff' do
    it 'returns an instance of FormattedCode::Diff' do
      parent_revision = Solutions::Revision.new(nil, double(:revision, code: 'puts 1'))
      revision = Solutions::Revision.new(parent_revision, double(:revision, code: 'puts 2'))

      allow(Language).to receive(:language).and_return 'ruby'
      allow(revision).to receive(:inline_comments_on_self).and_return(:comments)

      expect(FormattedCode::Diff).to receive(:new)
        .with('puts 1', 'puts 2', 'ruby', :comments)
        .and_return :result

      expect(revision.formatted_diff).to eq :result
    end

    it 'diffs with empty string as the source when there is no parent' do
      revision = Solutions::Revision.new(nil, double(:revision, code: 'puts 1'))

      allow(Language).to receive(:language).and_return 'ruby'
      allow(revision).to receive(:inline_comments_on_self).and_return(:comments)

      expect(FormattedCode::Diff).to receive(:new)
        .with('', 'puts 1', 'ruby', :comments)
        .and_return :result

      expect(revision.formatted_diff).to eq :result
    end
  end

  describe '#comments' do
    it 'returns non-inline comments' do
      revision = create :revision

      comment = create :comment, revision: revision
      create :inline_comment, revision: revision

      expect(Solutions::Revision.new(nil, revision).comments).to eq [comment]
    end
  end

  describe '#inline_comments_on_self' do
    it 'returns inline comments as a hash of line_number => [comment]' do
      revision = create :revision

      create :comment, revision: revision
      inline_comment = create :inline_comment, revision: revision, line_number: 3

      expect(Solutions::Revision.new(nil, revision).inline_comments).to eq(
        3 => [inline_comment]
      )
    end

    it 'does not return comments from previous revisions' do
      parent_revision = create :revision
      revision        = create :revision

      create :inline_comment, revision: parent_revision
      comment = create :inline_comment, revision: revision, line_number: 33

      expect(Solutions::Revision.new(nil, revision).inline_comments).to eq(
        33 => [comment]
      )
    end
  end

  describe '#inline_comments' do
    let(:parent_revision)         { create :revision }
    let(:revision)                { create :revision }
    let(:parent_history_revision) { Solutions::Revision.new(nil, parent_revision) }

    subject(:history_revision) { Solutions::Revision.new(parent_history_revision, revision) }

    it 'returns an empty hash when there are no comments' do
      expect(history_revision.inline_comments).to eq({})
    end

    it 'does not include non-inline comments' do
      create :comment, revision: parent_revision
      create :comment, revision: revision

      expect(history_revision.inline_comments).to eq({})
    end

    context 'with code changes preserving line numbers' do
      before do
        parent_revision.code = "source\ncode"
        revision.code        = "destination\ncode"
      end

      it 'includes comments made on the current revision' do
        comment = create :inline_comment, revision: revision, line_number: 0

        expect(history_revision.inline_comments).to eq(0 => [comment])
      end

      it 'includes comments made on unchanged lines from previous revisions' do
        comment = create :inline_comment, revision: parent_revision, line_number: 1

        expect(history_revision.inline_comments).to eq(1 => [comment])
      end

      it 'does not include comments on removed lines from previous revisions' do
        create :inline_comment, revision: parent_revision, line_number: 0

        expect(history_revision.inline_comments).to eq({})
      end
    end

    context 'with changes not preserving line numbers' do
      before do
        parent_revision.code = "source\ncode"
        revision.code        = "destination\ntwo\ncode"
      end

      it 'corrects the comments\' line numbers when transfering from previous revisions' do
        comment = create :inline_comment, revision: parent_revision, line_number: 1

        expect(history_revision.inline_comments).to eq(2 => [comment])
      end

      it 'combines comments on the same line from parent and from self' do
        comment_on_self   = create :inline_comment, revision: revision, line_number: 2
        comment_on_parent = create :inline_comment, revision: parent_revision, line_number: 1

        expect(history_revision.inline_comments).to eq(
          2 => [comment_on_parent, comment_on_self]
        )
      end
    end
  end
end
