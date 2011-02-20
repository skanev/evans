require 'spec_helper'

describe TopicsController do
  log_in_as :student

  describe "GET index" do
    it "assigns all topics to @topics" do
      Topic.stub :all => 'topics'
      get :index
      assigns(:topics).should == 'topics'
    end
  end

  describe "GET new" do
    it "assigns an empty topic to @topic" do
      Topic.stub :new => 'topic'
      get :new
      assigns(:topic).should == 'topic'
    end
  end

  describe "POST create" do
    let(:topic) { mock_model(Topic) }

    before do
      Topic.stub :new => topic
      topic.stub :user=
      topic.stub :save
    end

    it "denies access if not authenticated" do
      controller.stub :current_user => nil
      post :create
      response.should deny_access
    end

    it "constructs a topic with params[:topic]" do
      Topic.should_receive(:new).with('params')
      post :create, :topic => 'params'
    end

    it "assigns the user to the topic" do
      topic.should_receive(:user=).with(current_user)
      post :create
    end

    it "creates a new topic" do
      topic.should_receive(:save)
      post :create
    end

    it "redirects to the topic when successful" do
      topic.stub :save => true
      post :create
      response.should redirect_to(topic)
    end

    it "redisplays the form when unsuccessful" do
      topic.stub :save => false
      post :create
      response.should render_template(:new)
    end
  end

  describe "GET show" do
    before do
      Topic.stub :find
      Reply.stub :new
    end

    it "assigns the topic to @topic" do
      Topic.should_receive(:find).with(42).and_return('topic')
      get :show, :id => 42
      assigns(:topic).should == 'topic'
    end

    it "assigns an empty reply to @reply" do
      Reply.stub :new => 'reply'
      get :show, :id => 42
      assigns(:reply).should == 'reply'
    end
  end
end
