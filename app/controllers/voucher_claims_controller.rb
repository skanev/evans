class VoucherClaimsController < ApplicationController
  before_action :require_user

  def new
  end

  def create
    if Voucher.claim current_user, params[:code]
      flash[:notice] = 'Въведохте код успешно! Вече имате още една точка!'
      redirect_to dashboard_path
    else
      flash[:error] = 'Този код не съществува или вече е използван. Уверени ли сте в това, което правите?'
      redirect_to new_voucher_claim_path
    end
  end
end
