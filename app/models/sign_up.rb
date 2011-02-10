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

  def register_a_user
    generated_password = random_string(16)

    user = User.create! do |user|
      user.email = email
      user.full_name = full_name
      user.faculty_number = faculty_number
      user.password = generated_password
      user.password_confirmation = generated_password
    end

    RegistrationMailer.activation(user, generated_password).deliver

    user
  end

  private

  def random_string(length)
    (1..length).map { rand(36).to_s(36) }.join
  end
end
