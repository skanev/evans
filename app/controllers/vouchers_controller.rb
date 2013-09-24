class VouchersController < ApplicationController
  before_filter :require_admin

  def index
    @vouchers = Voucher.all
  end

  def new
  end

  def create
    Voucher.create_codes params[:codes]
    flash[:notice] = 'Кодовете са създадени'
    redirect_to vouchers_path
  end
end
