class Registration
  include ActiveModel::Conversion
  include ActiveModel::Validations
  include ActiveModel::Naming

  attr_accessor :full_name, :faculty_number, :email

  validate :matching_sign_up_exists

  def initialize(attributes = {})
    self.attributes = attributes
  end

  def attributes=(attributes)
    attributes.each do |key, value|
      send "#{key}=", value
    end
  end

  def create
    return false unless valid?

    sign_up.assign_to email
    RegistrationMailer.confirmation(sign_up).deliver
    true
  end

  private

  def sign_up
    SignUp.where(:full_name => full_name, :faculty_number => faculty_number).first
  end

  def matching_sign_up_exists
    if sign_up.nil?
      errors.add(:full_name, 'няма ги в списъците')
      errors.add(:faculty_number, 'няма го в списъците')
    end
  end
end
