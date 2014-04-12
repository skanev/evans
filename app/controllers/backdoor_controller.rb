class BackdoorController < ApplicationController
  before_action :prevent_from_execution_outside_test_environment

  def login
    sign_in User.find_by_email!(params[:email])
    render nothing: true
  end

  def logout
    sign_out
    render nothing: true
  end

  private

  def prevent_from_execution_outside_test_environment
    # Famous last words
    raise "This exception should never happen" unless Rails.env.test?
  end
end
