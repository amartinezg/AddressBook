class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  include ExceptionHandler
  include CanCan::ControllerAdditions

  before_action :permitted_params, if: :devise_controller?

  protected
  def permitted_params
    keys_allowed = [:name, :nickname, suscriptions_attributes: :organization_id]
    devise_parameter_sanitizer.permit(:sign_up, keys: keys_allowed)
  end
end
