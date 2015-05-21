class Challenge < ActiveRecord::Base
  include GeneratesNotifications
  
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
    generate_notifications_for User.all, title: "Новo предизвикателство: #{name}"
  end

end
