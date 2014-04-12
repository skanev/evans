class SignUpsController < ApplicationController
  before_action :require_admin

  def index
    @sign_ups = SignUp.all
  end

  def create
    @sign_up = SignUp.new params[:sign_up]
    if @sign_up.save
      redirect_to sign_ups_path, notice: 'Готово, майна. Студентът е записан.'
    else
      index
      render :index
    end
  end
end
