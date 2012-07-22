class Revision < ActiveRecord::Base
  validates :code, presence: true

  belongs_to :solution
end
