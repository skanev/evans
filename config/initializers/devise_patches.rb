# Security patch; more info here:
# http://blog.plataformatec.com.br/2013/01/security-announcement-devise-v2-2-3-v2-1-3-v2-0-5-and-v1-5-3-released/
Devise::ParamFilter.class_eval do
  def param_requires_string_conversion?(_value); true; end
end
