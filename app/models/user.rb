class User < ActiveRecord::Base
  devise :database_authenticatable, :rememberable, :trackable

  attr_accessible :password, :password_confirmation, :remember_me, :photo, :remove_photo
  attr_accessible :github, :twitter, :skype, :phone, :site, :about

  mount_uploader :photo, PhotoUploader
end
