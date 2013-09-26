class Attribution < ActiveRecord::Base
  belongs_to :user

  attr_accessible :reason, :link

  validates :reason, :link, presence: true
  validates :link, format: URI.regexp
end
