require 'spec_helper'

describe RepliesController do
  log_in_as :student

  describe "POST create" do
    let(:topic) { build_stubbed :topic }
    let(:reply) { build_stubbed :reply }

    before do
      allow(Topic).to receive(:find).and_return(topic)
      allow(topic).to receive_message_chain :replies, build: reply
      allow(reply).to receive(:user=)
      allow(reply).to receive(:save)
    end

    it "requires an authenticated user" do
      allow(controller).to receive(:current_user).and_return(nil)
      post :create, topic_id: '42'
      expect(response).to deny_access
    end

    it "looks up the topic by params[:topic_id]" do
      expect(Topic).to receive(:find).with('42')
      post :create, topic_id: '42', reply: attributes_for(:reply)
    end

    it "builds a reply with params[:reply]" do
      expect(topic.replies).to receive(:build).with(attributes_for(:reply).with_indifferent_access)
      post :create, topic_id: '42', reply: attributes_for(:reply)
    end

    it "assigns the current user to the reply" do
      expect(reply).to receive(:user=).with(current_user)
      post :create, topic_id: '42', reply: attributes_for(:reply)
    end

    it "saves the reply" do
      expect(reply).to receive(:save)
      post :create, topic_id: '42', reply: attributes_for(:reply)
    end

    context "when successful" do
      it "redirects to the reply" do
        allow(reply).to receive(:save).and_return(true)
        post :create, topic_id: '42', reply: attributes_for(:reply)
        expect(response).to redirect_to(topic_reply_path(topic, reply))
      end
    end

    context "when unsuccessful" do
      it "redisplays the form" do
        allow(reply).to receive(:save).and_return(false)
        post :create, topic_id: '42', reply: attributes_for(:reply)
        expect(response).to render_template(:new)
      end
    end
  end

  describe "GET edit" do
    let(:reply) { double }

    it "redirects to the page of the topic where the reply is" do
      allow(Reply).to receive(:find).and_return(reply)
      allow(reply).to receive(:topic_id).and_return(10)
      allow(reply).to receive(:page_in_topic).and_return(3)
      allow(reply).to receive(:id).and_return('20')

      get :show, topic_id: 10, id: '20'

      expect(response).to redirect_to(topic_path(10, page: 3, anchor: 'reply_20'))
    end
  end

  describe "GET edit" do
    let(:reply) { double }

    before do
      allow(Reply).to receive(:find).and_return(reply)
      allow(controller).to receive(:can_edit?).and_return(true)
    end

    it "assigns the reply to @reply" do
      expect(Reply).to receive(:find).with('20')
      get :edit, topic_id: 10, id: '20'
      expect(assigns(:reply)).to eq reply
    end

    it "denies access if the user cannot edit the reply" do
      allow(controller).to receive(:can_edit?).and_return(false)
      get :edit, topic_id: 10, id: '20'
      expect(response).to deny_access
    end
  end

  describe "PUT update" do
    let(:reply) { build_stubbed :reply }
    let(:topic) { build_stubbed :topic }

    before do
      allow(Reply).to receive(:find).and_return(reply)
      allow(reply).to receive(:update_attributes)
      allow(reply).to receive(:topic).and_return(topic)
      allow(reply).to receive(:save)
      allow(controller).to receive(:can_edit?).and_return(true)
    end

    it "denies access if the user cannot edit the reply" do
      allow(controller).to receive(:can_edit?).and_return(false)
      put :update, topic_id: 10, id: '20', reply: attributes_for(:reply)

      expect(response).to deny_access
    end

    it "assigns the reply to @reply" do
      expect(Reply).to receive(:find).with('20')
      put :update, topic_id: 10, id: '20', reply: attributes_for(:reply)
      expect(assigns(:reply)).to eq reply
    end

    it "updates the reply" do
      expect(reply).to receive(:update).with(attributes_for(:reply).with_indifferent_access)
      put :update, topic_id: 10, id: '20', reply: attributes_for(:reply)
    end

    it "redirects to the topic if successful" do
      allow(reply).to receive(:update).and_return(true)
      put :update, topic_id: 10, id: '20', reply: attributes_for(:reply)

      expect(response).to redirect_to(topic_reply_path(topic, reply))
    end

    it "redisplays the form if unsuccessful" do
      allow(reply).to receive(:update_attributes).and_return(false)
      put :update, topic_id: 10, id: '20', reply: attributes_for(:reply)

      expect(response).to render_template(:edit)
    end
  end
end
