class PreviewsController < ApplicationController
  def create
    @body = params[:body]
    render layout: false
  end
end
