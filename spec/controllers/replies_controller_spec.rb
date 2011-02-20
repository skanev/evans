require 'spec_helper'

describe RepliesController do
  log_in_as :student

  describe "POST create" do
    let(:topic) { mock_model(Topic) }
    let(:reply) { double }

    before do
      Topic.stub :find => topic
      topic.stub_chain :replies, :build => reply
      reply.stub :user=
      reply.stub :save
    end

    it "requires an authenticated user" do
      controller.stub :current_user => nil
      post :create, :topic_id => 42
      response.should deny_access
    end

    it "looks up the topic by params[:topic_id]" do
      Topic.should_receive(:find).with(42)
      post :create, :topic_id => 42
    end

    it "builds a reply with params[:reply]" do
      topic.replies.should_receive(:build).with('reply')
      post :create, :topic_id => 42, :reply => 'reply'
    end

    it "assigns the current user to the reply" do
      reply.should_receive(:user=).with(current_user)
      post :create, :topic_id => 42
    end

    it "saves the reply" do
      reply.should_receive(:save)
      post :create, :topic_id => 42
    end

    context "when successful" do
      it "redirects to the topic" do
        reply.stub :save => true
        post :create, :topic_id => 42
        response.should redirect_to(topic)
      end
    end

    context "when unsuccessful" do
      it "redisplays the form" do
        reply.stub :save => false
        post :create, :topic_id => 42
        response.should render_template(:new)
      end
    end
  end
end
