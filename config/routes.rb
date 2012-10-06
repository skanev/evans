require 'sidekiq/web'

Trane::Application.routes.draw do
  resource :registration, only: %w(new create)
  resources :activations, constraints: {id: /.+/}, only: %w(show update)

  resources :vouchers, only: %w(index new create)

  resources :announcements, except: %w(show destroy)
  resource :profile, only: %w(edit update)
  resource :dashboard, only: :show
  resources :voucher_claims, only: %w(new create)
  resources :quizzes, only: %w(show)
  resources :lectures, only: %w(index)

  resources :tasks, except: :destroy do
    get :guide, on: :collection
    resources :solutions, only: %w(index show update)
    resource :my_solution, only: %w(show update)
    resource :check, controller: :task_checks, only: :create
  end

  resources :revisions, only: [] do
    resources :comments, only: %w(create edit update)
  end

  resources :topics, except: :destroy do
    get :last_reply, on: :member
    resources :replies, except: %w(index new destroy)
  end

  resources :posts, only: :show do
    resource :star, only: %w(create destroy)
  end

  resources :polls do
    resource :my_answer
  end

  devise_for :users
  resources :users, only: %w(index show)
  resources :sign_ups, only: %w(index create)
  resources :activities, only: :index
  resources :points_breakdowns, only: :index

  get '/backdoor-login', to: 'backdoor_login#login' if Rails.env.test?

  mount Sidekiq::Web => '/queue', :constraints => AdminConstraint.new

  root to: "home#index"
end
