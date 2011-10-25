Trane::Application.routes.draw do
  resource :registration
  resources :activations, :constraints => {:id => /.+/}

  resources :vouchers

  resources :announcements
  resource :profile
  resource :dashboard
  resources :voucher_claims
  resources :quizzes
  resources :lectures

  resources :tasks do
    resource :statistics
    resource :my_solution
    resources :solutions do
      resources :comments
    end
  end

  resources :topics do
    get :last_reply, :on => :member
    resources :replies
  end

  resources :posts do
    resource :star
  end

  devise_for :users
  resources :users
  resources :sign_ups

  get '/backdoor-login', :to => 'backdoor_login#login' if Rails.env.test?

  root :to => "home#index"
end
