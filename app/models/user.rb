# encoding: utf-8
class User < ActiveRecord::Base
  has_many :solutions
  has_many :tips

  attr_protected :full_name, :faculty_number, :email, :admin

  mount_uploader :photo, PhotoUploader

  devise :database_authenticatable, :rememberable, :trackable, :recoverable

  validates_confirmation_of :password, unless: -> { password.blank? }

  def points
    points = 0
    points += 1 if photo.present?
    points += Voucher.where(user_id: id).count
    points += solutions.map(&:total_points).sum
    points += Post.where(user_id: id, starred: true).count
    points += QuizResult.where(user_id: id).map(&:points).sum
    points
  end

  def first_name
    name.split(' ').first
  end

  class << self
    def shorten_name(name)
      name.gsub(/^(\S+) .* (\S+)$/, '\1 \2')
    end

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
