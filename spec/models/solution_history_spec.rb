require 'spec_helper'

describe SolutionHistory do
  let(:solution) { create :solution }
  let(:history) { SolutionHistory.new solution }

  it "knows the revisions of a solution" do
    first  = create :revision, solution: solution
    second = create :revision, solution: solution

    history.revisions.should eq [first, second]
  end

  it "knows how many revisions are there" do
    first  = create :revision, solution: solution
    second = create :revision, solution: solution

    history.revisions_count.should eq 2
  end

  it "knows the comments of each revision" do
    first_revision  = create :revision, solution: solution
    second_revision = create :revision, solution: solution

    first  = create :comment, revision: first_revision
    second = create :comment, revision: first_revision
    third  = create :comment, revision: second_revision

    history.comments(first_revision).should eq [first, second]
    history.comments(second_revision).should eq [third]
  end

  it "knows how many comments there are" do
    first_revision  = create :revision, solution: solution
    second_revision = create :revision, solution: solution

    create :comment, revision: first_revision
    create :comment, revision: first_revision
    create :comment, revision: second_revision

    history.comments_count.should eq 3
  end

  it "knows the code of a revision" do
    revision = create :revision, solution: solution, code: 'solution code'
    history.code_for(revision).should eq 'solution code'
  end
end
