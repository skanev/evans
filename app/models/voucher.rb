class Voucher < ActiveRecord::Base
  class << self
    def create_codes(codes)
      codes.split(/\s+/).each do |code|
        create! :code => code
      end
    end
  end
end
