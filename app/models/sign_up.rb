class SignUp < ActiveRecord::Base
  class << self
    def with_token(token)
      return nil if token.blank?
      find_by_token(token)
    end
  end

  def assign_to(email)
    update_attributes! :email => email, :token => random_string(40)
  end

  private

  def random_string(length)
    (1..length).map { rand(36).to_s(36) }.join
  end
end
