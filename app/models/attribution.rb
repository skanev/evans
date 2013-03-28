# encoding: utf-8
class Attribution < ActiveRecord::Base
  belongs_to :user

  attr_accessible :reason, :link

  validates :reason, :link, presence: true
  validate :ensure_proper_link_format

  private

  def ensure_proper_link_format
    unless link =~ URI.regexp
      errors.add :link, 'Това не е истински URL'
    end
  end
end
