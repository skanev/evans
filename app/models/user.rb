class User < ActiveRecord::Base
  self.per_page = 20

  devise :database_authenticatable, :rememberable, :trackable

  attr_protected :full_name, :faculty_number, :email, :admin

  mount_uploader :photo, PhotoUploader

  def name
    full_name.gsub(/^(\w+) .* (\w+)$/, '\1 \2')
  end

  def points
    points = 0
    points += 1 if photo.present?
    points += Voucher.where(:user_id => id).count
    points
  end

  class << self
    def page(page_number)
      order('photo IS NULL ASC, created_at ASC').paginate :page => page_number
    end
  end
end
