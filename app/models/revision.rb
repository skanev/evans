class Revision < ActiveRecord::Base
  belongs_to :solution
  has_many :comments, -> { order 'comments.created_at ASC' }

  validates :code, presence: true

  delegate :task, :commentable_by?, to: :solution
end
