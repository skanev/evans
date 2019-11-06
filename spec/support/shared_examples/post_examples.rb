shared_examples_for 'Post' do
  it { should belong_to(:user) }

  it { should validate_presence_of(:body) }
  it { should validate_presence_of(:user_id) }

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
    expect(post).to be_editable_by post.user
    expect(post).to be_editable_by create(:admin)

    expect(post).to_not be_editable_by create(:user)
    expect(post).to_not be_editable_by nil
  end

  it "can return a title for the containing topic" do
    expect(post).to respond_to(:topic_title)
  end
end
