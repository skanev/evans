shared_examples_for Post do
  it { should belong_to(:user) }

  it { should validate_presence_of(:body) }
  it { should validate_presence_of(:user_id) }

  it { should_not allow_mass_assignment_of(:user_id) }
  it { should_not allow_mass_assignment_of(:starred) }

  def post
    raise 'Example groups need to define a method #post that returns the record'
  end

  it "can be given a star" do
    expect do
      post.star
      post.reload
    end.to change(post, :starred?).from(false).to(true)
  end
end
