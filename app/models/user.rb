# encoding: utf-8
class User < ActiveRecord::Base
  has_many :solutions

  attr_protected :full_name, :faculty_number, :email, :admin

  mount_uploader :photo, PhotoUploader

  devise :database_authenticatable, :rememberable, :trackable

  validates_confirmation_of :password, unless: -> { password.blank? }

  def name
    full_name.gsub(/^(\S+) .* (\S+)$/, '\1 \2')
  end

  def points
    points = 0
    points += 1 if photo.present?
    points += Voucher.where(user_id: id).count
    points += solutions.map(&:points).sum
    points += Post.where(user_id: id, starred: true).count
    points += QuizResult.where(user_id: id).map(&:points).sum
    points
  end

  class << self
    def page(page_number)
      sort_order = <<-END
        (CASE
          WHEN photo = '' THEN 1
          WHEN photo IS NULL THEN 1
          ELSE 0
        END) ASC,
        created_at ASC
      END
      order(sort_order).paginate page: page_number, per_page: 32
    end
  end
end
