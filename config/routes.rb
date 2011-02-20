Trane::Application.routes.draw do
  resource :registration
  resources :activations, :constraints => {:id => /.+/}

  resources :sign_ups

  resources :topics do
    resources :replies
  end

  devise_for :users

  get '/backdoor-login', :to => 'backdoor_login#login' if Rails.env.test?
  root :to => "home#index"
end
