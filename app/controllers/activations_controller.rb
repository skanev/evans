class ActivationsController < ApplicationController
  def show
    @activation = Activation.for params[:id]

    if @activation.nil?
      redirect_to root_path, error: 'Несъществуващ активационен ключ. Може би вече сте се регистрирали?'
    end
  end

  def update
    @activation = Activation.for params[:id]
    if @activation.submit params[:activation]
      sign_in @activation.user_created
      redirect_to root_path, notice: 'Честито! Регистрацията ви е успешна. Забавлявайте се.'
    else
      render :show
    end
  end
end
