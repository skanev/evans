require 'spec_helper'

describe Topic do
  it "does not allow mass reassignment of user_id" do
    original, modified = create(:user), create(:user)
    topic = create :topic, user: original

    topic.update_attributes! user_id: modified.id

    expect(topic.reload.user).to eq original
  end

  it "supports paging, ordering in reverse chronological order of the last post" do
    create_topic_with_last_reply_at = lambda do |timestamp|
      create(:reply, created_at: timestamp).topic
    end

    second = create_topic_with_last_reply_at.call 2.days.ago
    first  = create_topic_with_last_reply_at.call 1.day.ago

    allow(Topic).to receive(:per_page).and_return(1)

    expect(Topic.boards_page(1)).to eq [first]
    expect(Topic.boards_page(2)).to eq [second]
  end

  it "can paginate its replies" do
    topic  = create :topic, created_at: 3.days.ago
    first  = create :reply, topic: topic, created_at: 2.days.ago
    second = create :reply, topic: topic, created_at: 1.day.ago

    allow(Reply).to receive(:per_page).and_return(1)

    expect(topic.replies_on_page(1)).to eq [first]
    expect(topic.replies_on_page(2)).to eq [second]
  end

  it "can be edited by its owner or by an admin" do
    topic = create :topic

    expect(topic).to be_editable_by topic.user
    expect(topic).to be_editable_by create(:admin)

    expect(topic).to_not be_editable_by create(:user)
    expect(topic).to_not be_editable_by nil
  end

  it "can tell how many pages of replies it has" do
    topic_with_replies = lambda do |count|
      topic = create :topic
      count.times { create :reply, topic: topic }
      topic.reload
    end

    allow(Reply).to receive(:per_page).and_return(2)

    expect(topic_with_replies[0].pages_of_replies).to eq 1
    expect(topic_with_replies[2].pages_of_replies).to eq 1
    expect(topic_with_replies[3].pages_of_replies).to eq 2
  end

  it "gives its own title when asked for the containing topic's title" do
    expect(Topic.new(title: 'Title').topic_title).to eq 'Title'
  end

  describe "last reply id" do
    let(:topic) { create :topic }

    it "is the id of the last reply if there are any replies" do
      one = create :reply, topic: topic
      two = create :reply, topic: topic

      expect(topic.last_reply_id).to eq two.id
    end

    it "is nil if there were no replies" do
      expect(topic.last_reply_id).to be_nil
    end
  end

  describe "last post on boards page" do
    let(:topic_with_last_post) { Topic.boards_page(1).first }

    it "is the topic itself initially" do
      Timecop.freeze(Time.now) do
        topic = create :topic

        expect(topic_with_last_post.last_poster).to eq topic.user
        expect(topic_with_last_post.last_post_at).to be_within(1.second).of(Time.zone.now)
      end
    end

    it "is updated whenever a new reply is created" do
      topic = nil

      Timecop.freeze(1.day.ago) do
        topic = create :topic
      end

      Timecop.freeze(1.hour.ago) do
        reply = create :reply, topic: topic

        expect(topic_with_last_post.last_post_at).to be_within(1.second).of(Time.zone.now)
        expect(topic_with_last_post.last_poster).to eq reply.user
      end
    end
  end

  it_behaves_like 'Post' do
    let(:post) { create :topic }
    let(:starred_post) { create :topic, starred: true }
  end
end
