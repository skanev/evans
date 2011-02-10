class SignUp < ActiveRecord::Base
  class << self
    def with_token(token)
      return nil if token.blank?
      find_by_token(token)
    end
  end

  def assign_to(email)
    update_attributes! :email => email, :token => generate_random_token
  end

  def register_a_user
    user = User.create! do |user|
      user.email = email
      user.full_name = full_name
      user.faculty_number = faculty_number
      user.password = '123456'
      user.password_confirmation = '123456'
    end

    RegistrationMailer.activation(user, '123456').deliver

    user
  end

  private

  def generate_random_token
    (1..40).map { rand(36).to_s(36) }.join
  end
end
