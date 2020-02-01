require 'spec_helper'

describe TopicsController do
  describe "GET index" do
    it "assigns a page of topics to @topics" do
      expect(Topic).to receive(:boards_page).with('3').and_return 'topics'
      get :index, page: '3'
      expect(assigns(:topics)).to eq 'topics'
    end

    it "shows the first page by default" do
      expect(Topic).to receive(:boards_page).with(1)
      get :index
    end
  end

  describe "GET new" do
    log_in_as :student

    it "assigns an empty topic to @topic" do
      Topic.stub new: 'topic'
      get :new
      expect(assigns(:topic)).to eq 'topic'
    end
  end

  describe "POST create" do
    log_in_as :student

    let(:topic) { mock_model(Topic) }

    before do
      Topic.stub new: topic
      topic.stub :user=
      topic.stub :save
    end

    it "denies access if not authenticated" do
      controller.stub current_user: nil
      post :create
      expect(response).to deny_access
    end

    it "constructs a topic with params[:topic]" do
      expect(Topic).to receive(:new).with('params')
      post :create, topic: 'params'
    end

    it "assigns the user to the topic" do
      expect(topic).to receive(:user=).with(current_user)
      post :create
    end

    it "creates a new topic" do
      expect(topic).to receive(:save)
      post :create
    end

    it "redirects to the topic when successful" do
      topic.stub save: true
      post :create
      expect(response).to redirect_to(topic)
    end

    it "redisplays the form when unsuccessful" do
      topic.stub save: false
      post :create
      expect(response).to render_template(:new)
    end
  end

  describe "GET show" do
    let(:topic) { double }

    before do
      Topic.stub find: topic
      topic.stub :replies_on_page
      Reply.stub :new
    end

    it "assigns the topic to @topic" do
      expect(Topic).to receive(:find).with('42').and_return(topic)
      get :show, id: '42'
      expect(assigns(:topic)).to eq topic
    end

    it "assigns a page of replies to @replies" do
      expect(topic).to receive(:replies_on_page).with('4').and_return('page 4')
      get :show, id: '42', page: '4'
      expect(assigns(:replies)).to eq 'page 4'
    end

    it "assigns an empty reply to @reply" do
      Reply.stub new: 'reply'
      get :show, id: '42'
      expect(assigns(:reply)).to eq 'reply'
    end
  end

  describe "GET edit" do
    log_in_as :student

    let(:topic) { double }

    before do
      Topic.stub find: topic
      controller.stub can_edit?: true
    end

    it "assigns the topic to @topic" do
      expect(Topic).to receive(:find).with('42')
      get :edit, id: '42'
      expect(assigns(:topic)).to eq topic
    end

    it "denies access if the user cannot edit the topic" do
      expect(controller).to receive(:can_edit?).with(topic).and_return(false)
      get :edit, id: '42'
      expect(response).to deny_access
    end
  end

  describe "PUT update" do
    log_in_as :student

    let(:topic) { mock_model(Topic) }

    before do
      Topic.stub find: topic
      topic.stub :update_attributes
      controller.stub can_edit?: true
    end

    it "assigns the topic to @topic" do
      expect(Topic).to receive(:find).with('42').and_return(topic)
      put :update, id: '42'
      expect(assigns(:topic)).to eq topic
    end

    it "updates the topic" do
      expect(topic).to receive(:update_attributes).with('attributes')
      put :update, id: '42', topic: 'attributes'
    end

    it "displays the topic on success" do
      topic.stub update_attributes: true
      put :update, id: '42'
      expect(response).to redirect_to(topic)
    end

    it "redisplays the edit form on failure" do
      topic.stub update_attributes: false
      put :update, id: '42'
      expect(response).to render_template(:edit)
    end
  end

  describe "GET last_reply" do
    let(:topic) { mock_model(Topic) }

    before do
      Topic.stub find: topic
    end

    it "redirects to the topic itself if it has no replies" do
      topic.stub last_reply_id: nil

      get :last_reply, id: '42'

      expect(response).to redirect_to(topic_path(topic))
    end

    it "redirects to the last page of the topic" do
      topic.stub last_reply_id: 20

      get :last_reply, id: 10

      expect(response).to redirect_to(topic_reply_path(topic, 20))
    end
  end
end
