class Revision < ActiveRecord::Base
  validates :code, presence: true

  belongs_to :solution
  has_many :comments

  delegate :task, :commentable_by?, to: :solution
end
