require 'spec_helper'

describe AttributionsController do
  log_in_as :admin

  describe 'POST create' do
    before do
      User.stub find: create(:user)
    end

    it 'requires an authenticated admin user' do
      controller.stub current_user: create(:user)
      post :create, user_id: '42'
      response.should deny_access
    end

    it 'looks up the user by params[:user_id]' do
      User.should_receive(:find).with('42')
      post :create, user_id: '42'
    end
  end

  describe 'PUT update' do
    let(:attribution) { build_stubbed :attribution }
    let(:user) { build_stubbed :user }

    before do
      Attribution.stub find: attribution
      attribution.stub :update_attributes
      attribution.stub user: user
    end

    it 'requires an authenticated admin user' do
      controller.stub current_user: create(:user)
      put :update, user_id: '42', id: '1'
      response.should deny_access
    end

    it 'looks up the user by params[:user_id]' do
      User.should_receive(:find).with('42')
      put :update, user_id: '42', id: '1'
    end
  end
end
