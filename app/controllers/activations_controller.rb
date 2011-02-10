class ActivationsController < ApplicationController
  def activate
    sign_up = SignUp.with_token params[:token]

    if sign_up.present?
      sign_up.register_a_user
      flash[:notice] = 'Потребителят ви е създаден успешно'
    else
      flash[:error] = 'Несъществуващ активационнен ключ. Може би вече сте се регистрирали успешно?'
    end

    redirect_to root_path
  end
end
