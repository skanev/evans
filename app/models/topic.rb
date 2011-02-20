class Topic < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :title, :body, :user

  attr_accessible :title, :body
end
