class Task < ActiveRecord::Base
  validates_presence_of :name, :description

  has_many :solutions

  def closed?
    closes_at.past?
  end
end
