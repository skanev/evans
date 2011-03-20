Trane::Application.routes.draw do
  resource :registration
  resources :activations, :constraints => {:id => /.+/}

  resources :vouchers

  resources :announcements
  resources :tasks
  resource :profile
  resource :dashboard
  resources :voucher_claims

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
