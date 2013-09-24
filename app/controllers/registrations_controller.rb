class RegistrationsController < ApplicationController
  def new
    @registration = Registration.new
  end

  def create
    @registration = Registration.new params[:registration]

    if @registration.create
      redirect_to root_path, notice: 'Супер. Проверете си пощата за допълнителни инструкции.'
    else
      render :new
    end
  end
end
