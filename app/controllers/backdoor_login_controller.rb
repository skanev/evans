class BackdoorLoginController < ApplicationController
  def login
    # Famous last words
    raise "This exception should never happen" unless Rails.env.test?
    sign_in User.find_by_email!(params[:email])
    render nothing: true
  end
end
