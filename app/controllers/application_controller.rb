class ApplicationController < ActionController::Base
  protect_from_forgery

  private

  def require_admin
    unless current_user.try(:admin?)
      redirect_to root_path, :flash => {:error => 'Нямате достъп до тази страница'}
    end
  end
end
