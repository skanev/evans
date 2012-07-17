class Voucher < ActiveRecord::Base
  belongs_to :user

  def claimed?
    user_id?
  end

  class << self
    def create_codes(codes)
      codes.split(/\s+/).each do |code|
        create! code: code
      end
    end

    def claim(user, code)
      voucher = find_by_code(code)
      return false if voucher.nil? or voucher.claimed?
      voucher.update_attributes! user_id: user.id, claimed_at: Time.now
    end
  end
end
