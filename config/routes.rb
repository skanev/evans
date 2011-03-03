Trane::Application.routes.draw do
  resource :registration
  resources :activations, :constraints => {:id => /.+/}

  resources :vouchers

  resource :profile

  resources :topics do
    get :last_reply, :on => :member
    resources :replies
  end

  devise_for :users
  resources :users
  resources :sign_ups

  get '/backdoor-login', :to => 'backdoor_login#login' if Rails.env.test?

  root :to => "home#index"
end
