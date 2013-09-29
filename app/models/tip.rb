class Tip < ActiveRecord::Base
  validates_presence_of :user
  belongs_to :user

  def editable_by?(user)
    self.user == user or user.try(:admin?)
  end

  def update_as(user, params = {})
    if not user.admin?
      params.delete(:published_at)
    end
    update_attributes(params)
  end

  private

  class << self
    def list_as(user)
      if not user
        Tip.published.in_reverse_chronological_order
      elsif user.admin?
        Tip.in_reverse_chronological_order
      else
        tips = Tip.where('published_at < ? OR user_id = ?', Time.now, user.id)
        tips.in_reverse_chronological_order
      end
    end

    def build_as(user, params = {})
      new(params).tap do |tip|
        tip.user = user

        if user.admin?
          tip.published_at = default_new_published_at
        else
          tip.published_at = nil
        end
      end
    end

    def current
      published.last
    end

    def published
      where('published_at < ?', Time.now)
    end

    def in_reverse_chronological_order
      order('published_at DESC')
    end

    private

    def default_new_published_at
      chronologically_last = order('published_at ASC').last

      if chronologically_last
        chronologically_last.published_at + 1.day
      else
        Time.now
      end
    end
  end
end
