Trane::Application.routes.draw do
  resource :registration
  resources :activations, :constraints => {:id => /.+/}

  resource :profile

  resources :topics do
    get :last_reply, :on => :member
    resources :replies
  end

  resources :sign_ups

  devise_for :users

  get '/backdoor-login', :to => 'backdoor_login#login' if Rails.env.test?
  root :to => "home#index"
end
