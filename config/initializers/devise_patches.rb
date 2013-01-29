# Security patch; more info here:
# http://blog.plataformatec.com.br/2013/01/security-announcement-devise-v2-2-3-v2-1-3-v2-0-5-and-v1-5-3-released/
Devise::Models::Authenticatable::ClassMethods.class_eval do
  def auth_param_requires_string_conversion?(value); true; end
end
