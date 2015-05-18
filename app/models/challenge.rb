class Challenge < ActiveRecord::Base
  has_many :solutions, class_name: 'ChallengeSolution'

  validates :name, :description, presence: true

  after_create :post_notification

  class << self
    def in_chronological_order
      order('created_at ASC')
    end

    def visible
      where(hidden: false).in_chronological_order
    end
  end

  def closed?
    closes_at.past?
  end

  def post_notification
    notification = Notification.new
    notification.title = "Новo предизвикателство: #{name}"
    notification.source = self
    notification.save
  end
end
