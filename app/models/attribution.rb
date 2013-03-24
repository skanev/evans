class Attribution < ActiveRecord::Base
  belongs_to :user
  attr_accessible :reason
end
