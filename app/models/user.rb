class User < ActiveRecord::Base
  scope :admins,   -> { where(admin: true) }
  scope :students, -> { where(admin: false) }

  has_many :solutions
  has_many :tips
  has_many :attributions

  attr_protected :full_name, :faculty_number, :email, :admin

  mount_uploader :photo, PhotoUploader

  devise :database_authenticatable, :rememberable, :trackable, :recoverable

  validates :password, confirmation: true, unless: -> { password.blank? }

  def points
    return 0 if admin?
    PointsBreakdown.find(id).total
  end

  def rank
    return 0 if admin?
    PointsBreakdown.find(id).rank
  end

  def first_name
    name.split(' ').first
  end

  class << self
    def shorten_name(name)
      name.gsub(/^(\S+) .* (\S+)$/, '\1 \2')
    end

    def sorted
      order <<-END
        (CASE
          WHEN photo = '' THEN 1
          WHEN photo IS NULL THEN 1
          ELSE 0
        END) ASC,
        created_at ASC
      END
    end

    def at_page(page_number)
      paginate page: page_number, per_page: 32
    end
  end
end
