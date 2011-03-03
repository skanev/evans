class User < ActiveRecord::Base
  self.per_page = 20

  devise :database_authenticatable, :rememberable, :trackable

  attr_protected :full_name, :faculty_number, :email, :admin

  mount_uploader :photo, PhotoUploader

  class << self
    def page(page_number)
      order('photo IS NULL ASC, created_at ASC').paginate :page => page_number
    end
  end
end
