class User < ActiveRecord::Base
  scope :admins,   -> { where(admin: true) }
  scope :students, -> { where(admin: false) }

  has_many :solutions
  has_many :tips
  has_many :attributions

  attr_protected :full_name, :faculty_number, :email, :admin

  mount_uploader :photo, PhotoUploader

  devise :database_authenticatable, :rememberable, :trackable, :recoverable

  validates_confirmation_of :password, unless: -> { password.blank? }

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

    def next_fake_faculty_number
      last_number = User.
        where("faculty_number LIKE 'x%'").
        pluck(:faculty_number).
        map { |n| n[/^x(\d+)$/, 1] }.
        compact.
        map(&:to_i).
        sort.
        last || 0

      sprintf 'x%05d', last_number + 1
    end
  end
end
