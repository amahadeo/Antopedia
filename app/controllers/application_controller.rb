class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  include Pundit
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  
  rescue_from Pundit::NotAuthorizedError do |exception|
    redirect_to wikis_path, alert: "Sorry, not authorized for that action."
  end
  
  def after_sign_in_path_for(resource)
    wikis_path
  end
  
  def after_sign_out_path_for(resource)
    wikis_path
  end
  
  protected
    
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :username
  end
end
