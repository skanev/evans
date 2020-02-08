require 'spec_helper'

describe Reply do
  it "can be edited by its owner or by an admin" do
    reply = create :reply

    expect(reply).to be_editable_by reply.user
    expect(reply).to be_editable_by create(:admin)

    expect(reply).to_not be_editable_by nil
    expect(reply).to_not be_editable_by create(:user)
  end

  it "can tell on which page of the topic it is" do
    topic  = create :topic
    first  = create :reply, topic: topic
    second = create :reply, topic: topic
    third  = create :reply, topic: topic

    allow(Reply).to receive(:per_page).and_return(2)

    expect(first.page_in_topic).to eq 1
    expect(second.page_in_topic).to eq 1
    expect(third.page_in_topic).to eq 2
  end

  it "gives the title of its topic when asked for the containing topic's title" do
    topic = create :topic, title: 'Topic title'
    reply = create :reply, topic: topic

    expect(reply.topic_title).to eq 'Topic title'
  end

  it_behaves_like 'Post' do
    let(:post) { create :reply }
    let(:starred_post) { create :reply, starred: true }
  end
end
