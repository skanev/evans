class Activation
  include ActiveModel::Conversion
  include ActiveModel::Validations
  include ActiveModel::Naming

  attr_accessor :password, :password_confirmation

  validates :password, presence: true, confirmation: true

  def initialize(sign_up)
    @sign_up = sign_up
  end

  class << self
    def for(token)
      sign_up = SignUp.find_by_token token
      sign_up ? new(sign_up) : nil
    end
  end

  def submit(attributes = {})
    self.attributes = attributes

    if valid?
      create_user
      true
    else
      false
    end
  end

  def user_created
    @user
  end

  def persisted?
    true
  end

  def to_param
    @sign_up.token
  end

  private

  def create_user
    @user = User.create! do |user|
      user.email = @sign_up.email
      user.full_name = @sign_up.full_name
      user.name = User.shorten_name @sign_up.full_name
      user.faculty_number = @sign_up.faculty_number
      user.password = password
      user.password_confirmation = password_confirmation
    end

    @sign_up.destroy

    RegistrationMailer.activation(@user).deliver
  end

  def attributes=(attributes)
    attributes.each do |key, value|
      send "#{key}=", value
    end
  end
end
