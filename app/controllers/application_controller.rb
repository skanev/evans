class ApplicationController < ActionController::Base
  protect_from_forgery

  private

  def require_user
    unless current_user
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
