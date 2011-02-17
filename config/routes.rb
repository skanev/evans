Trane::Application.routes.draw do
  resource :registration
  resources :activations, :constraints => {:id => /.+/}

  devise_for :users

  root :to => "home#index"
end
