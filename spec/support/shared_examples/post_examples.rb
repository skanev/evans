shared_examples_for 'Post' do
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

  it "can be unstarred" do
    expect do
      starred_post.unstar
      starred_post.reload
    end.to change(starred_post, :starred?).from(true).to(false)
  end

  it "can be edited by its owner or by an admin" do
    post.should be_editable_by post.user
    post.should be_editable_by create(:admin)

    post.should_not be_editable_by create(:user)
    post.should_not be_editable_by nil
  end

  it "can return a title for the containing topic" do
    post.should respond_to(:topic_title)
  end
end
