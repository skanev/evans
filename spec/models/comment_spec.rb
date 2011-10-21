require 'spec_helper'

describe Comment do
  it { should_not allow_mass_assignment_of(:user_id) }
  it { should_not allow_mass_assignment_of(:solution_id) }

  it { should validate_presence_of(:body) }

  describe "(editing)" do
    let(:comment) { build :comment }

    it "is editable by its author" do
      comment.should be_editable_by comment.user
    end

    it "is editable by admins" do
      comment.should be_editable_by build(:admin)
    end

    it "is not editable by other users" do
      comment.should_not be_editable_by build(:user)
    end
  end
end
