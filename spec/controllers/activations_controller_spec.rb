require 'spec_helper'

describe ActivationsController do
  describe "GET show" do
    it "assigns the current activation to @activation" do
      Activation.should_receive(:for).with('token').and_return('activation')
      get :show, :id => 'token'
      assigns[:activation].should == 'activation'
    end

    it "displays an error message if the activation token is invalid" do
      Activation.stub :for => nil
      get :show, :id => 'token'
      response.should redirect_to(root_path)
    end
  end

  describe "PUT update" do
    let(:activation) { double }

    before do
      Activation.stub :for => activation
    end

    it "submits the activation" do
      activation.should_receive(:submit).with('parameters')
      put :update, :id => 'token', :activation => 'parameters'
    end

    it "redirects to the home page if the activation is successful" do
      activation.stub :submit => true
      put :update, :id => 'token', :activation => 'parameters'
      response.should redirect_to(root_path)
    end

    it "redisplays the form if the activation is invalid" do
      activation.stub :submit => false
      put :update, :id => 'token', :activation => 'parameters'
      response.should render_template(:show)
    end
  end
end
