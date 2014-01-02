Apotomo::Widget.class_eval do
  include Devise::Controllers::Helpers if defined? Devise
  helper_method :current_user
  # helper_method :options
end
