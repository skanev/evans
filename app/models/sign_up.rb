class SignUp < ActiveRecord::Base
  validates_presence_of :full_name
  validates_presence_of :faculty_number
  validates_uniqueness_of :faculty_number

  class << self
    def with_token(token)
      return nil if token.blank?
      find_by_token(token)
    end
  end

  def assign_to(email)
    update_attributes! email: email, token: random_string(40)
  end

  private

  def random_string(length)
    (1..length).map { rand(36).to_s(36) }.join
  end
end
