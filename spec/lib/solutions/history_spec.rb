require 'spec_helper'

describe Solutions::History do
  describe '#revisions_count' do
    it 'returns the number of revisions' do
      solution = build_stubbed :solution, revisions: [
        build(:revision),
        build(:revision)
      ]

      expect(Solutions::History.new(solution).revisions_count).to eq 2
    end
  end

  describe '#comments_count' do
    it 'counts inline comments' do
      revision = create :revision, comments: [create(:inline_comment)]
      solution = create :solution, revisions: [revision]

      expect(Solutions::History.new(solution).comments_count).to eq 1
    end

    it 'counts non-inline comments' do
      revision = create :revision, comments: [create(:comment)]
      solution = create :solution, revisions: [revision]

      expect(Solutions::History.new(solution).comments_count).to eq 1
    end
  end

  describe '#last_revision' do
    it 'returns the last Solutions::Revision object in the history' do
      first_revision = build :revision
      last_revision  = build :revision
      solution       = build_stubbed :solution, revisions: [first_revision, last_revision]

      history = Solutions::History.new(solution)

      expect(history.last_revision).to be_kind_of Solutions::Revision
      expect(history.last_revision.model).to eq last_revision
    end

    it 'returns nil when there are no revisions' do
      solution = build_stubbed :solution, revisions: []
      history  = Solutions::History.new(solution)

      expect(history.last_revision).to be nil
    end
  end

  describe '#revisions' do
    it 'calls last_revision.revisions' do
      solution = build_stubbed :solution, revisions: [build(:revision), build(:revision)]
      history  = Solutions::History.new(solution)

      expect(history.last_revision).to receive(:revisions).and_return 'revisions'

      expect(history.revisions).to eq 'revisions'
    end

    it 'returns an empty sequence when there are no revisions' do
      solution = build_stubbed :solution, revisions: []
      history  = Solutions::History.new(solution)

      expect(history.revisions.to_a).to eq []
    end
  end

  it 'builds a revision history, passing the parent to each revision' do
    revision_one = build :revision
    revision_two = build :revision
    solution     = build_stubbed :solution, revisions: [revision_one, revision_two]

    revision_one_double = double 'revision one'
    revision_two_double = double 'revision two'

    expect(Solutions::Revision).to receive(:new)
      .with(nil, revision_one)
      .and_return(revision_one_double)

    expect(Solutions::Revision).to receive(:new)
      .with(revision_one_double, revision_two)
      .and_return(revision_two_double)

    history = Solutions::History.new(solution)

    expect(history.last_revision).to be revision_two_double
  end
end
