class Topic < ActiveRecord::Base
  belongs_to :user
  has_many :replies

  validates_presence_of :title, :body, :user

  attr_accessible :title, :body
end
