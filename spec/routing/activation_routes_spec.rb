require 'spec_helper'

describe "Activation routing" do
  it "routes /activate/token to SignUpsController" do
    {:get => '/activate/token'}.should route_to(:controller => 'activations', :action => 'activate', :token => 'token')
  end

  it "routes activation_path(token) via its token" do
    {:get => activation_path('token')}.should route_to(:controller => 'activations', :action => 'activate', :token => 'token')
  end
end
