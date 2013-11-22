class PreviewsController < ApplicationController
  def create
    render text: Markup.format(params[:body])
  end
end
