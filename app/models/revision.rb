class Revision < ActiveRecord::Base
  validates :code, presence: true

  belongs_to :solution
  has_many :comments, -> { order 'comments.created_at ASC' }

  delegate :task, :commentable_by?, to: :solution
end
