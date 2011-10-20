require 'spec_helper'

describe Comment do
  it { should_not allow_mass_assignment_of(:user_id) }
  it { should_not allow_mass_assignment_of(:solution_id) }

  it { should validate_presence_of(:body) }
end
