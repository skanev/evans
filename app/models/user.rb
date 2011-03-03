class User < ActiveRecord::Base
  devise :database_authenticatable, :rememberable, :trackable

  attr_protected :full_name, :faculty_number, :email, :admin

  mount_uploader :photo, PhotoUploader
end
