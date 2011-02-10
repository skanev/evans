Trane::Application.routes.draw do
  resource :registration

  get '/activate/:token', :to => 'activations#activate', :constraints => {:token => /.+/}, :as => :activation

  devise_for :users

  root :to => "home#index"
end
