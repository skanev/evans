class ApplicationController < ActionController::Base
  helper_method :can_edit?, :logged_in?

  protect_from_forgery

  private

  def logged_in?
    !!current_user
  end

  def require_user
    unless logged_in?
      redirect_to root_path, :flash => {:error => 'Трябва да влезнете в системата за да направите това.'}
    end
  end

  def require_admin
    unless current_user.try(:admin?)
      redirect_to root_path, :flash => {:error => 'Нямате достъп до тази страница.'}
    end
  end

  def deny_access
    redirect_to root_path, :flash => {:error => 'Нямате достъп до тази страница.'}
  end

  def can_edit?(something)
    something.can_be_edited_by? current_user
  end
end
