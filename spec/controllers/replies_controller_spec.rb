require 'spec_helper'

describe RepliesController do
  log_in_as :student

  describe "POST create" do
    let(:topic) { build_stubbed :topic }
    let(:reply) { build_stubbed :reply }

    before do
      Topic.stub find: topic
      topic.stub_chain :replies, build: reply
      reply.stub :user=
      reply.stub :save
    end

    it "requires an authenticated user" do
      controller.stub current_user: nil
      post :create, topic_id: '42'
      response.should deny_access
    end

    it "looks up the topic by params[:topic_id]" do
      Topic.should_receive(:find).with('42')
      post :create, topic_id: '42'
    end

    it "builds a reply with params[:reply]" do
      topic.replies.should_receive(:build).with('reply')
      post :create, topic_id: '42', reply: 'reply'
    end

    it "assigns the current user to the reply" do
      reply.should_receive(:user=).with(current_user)
      post :create, topic_id: '42'
    end

    it "saves the reply" do
      reply.should_receive(:save)
      post :create, topic_id: '42'
    end

    context "when successful" do
      it "redirects to the reply" do
        reply.stub save: true
        post :create, topic_id: '42'
        response.should redirect_to(topic_reply_path(topic, reply))
      end
    end

    context "when unsuccessful" do
      it "redisplays the form" do
        reply.stub save: false
        post :create, topic_id: '42'
        response.should render_template(:new)
      end
    end
  end

  describe "GET edit" do
    let(:reply) { double }

    it "redirects to the page of the topic where the reply is" do
      Reply.stub find: reply
      reply.stub topic_id: 10
      reply.stub page_in_topic: 3
      reply.stub id: '20'

      get :show, topic_id: 10, id: '20'

      response.should redirect_to(topic_path(10, page: 3, anchor: 'reply_20'))
    end
  end

  describe "GET edit" do
    let(:reply) { double }

    before do
      Reply.stub find: reply
      controller.stub can_edit?: true
    end

    it "assigns the reply to @reply" do
      Reply.should_receive(:find).with('20')
      get :edit, topic_id: 10, id: '20'
      assigns(:reply).should eq reply
    end

    it "denies access if the user cannot edit the reply" do
      controller.stub can_edit?: false
      get :edit, topic_id: 10, id: '20'
      response.should deny_access
    end
  end

  describe "PUT update" do
    let(:reply) { build_stubbed :reply }
    let(:topic) { build_stubbed :topic }

    before do
      Reply.stub find: reply
      reply.stub :update_attributes
      reply.stub topic: topic
      controller.stub can_edit?: true
    end

    it "denies access if the user cannot edit the reply" do
      controller.stub can_edit?: false
      put :update, topic_id: 10, id: '20'
      response.should deny_access
    end

    it "assigns the reply to @reply" do
      Reply.should_receive(:find).with('20')
      put :update, topic_id: 10, id: '20'
      assigns(:reply).should eq reply
    end

    it "updates the reply" do
      reply.should_receive(:update_attributes).with('attributes')
      put :update, topic_id: 10, id: '20', reply: 'attributes'
    end

    it "redirects to the topic if successful" do
      reply.stub update_attributes: true
      put :update, topic_id: 10, id: '20'
      response.should redirect_to(topic_reply_path(topic, reply))
    end

    it "redisplays the form if unsuccessful" do
      reply.stub update_attributes: false
      put :update, topic_id: 10, id: '20'
      response.should render_template(:edit)
    end
  end
end
