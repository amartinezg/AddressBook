class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  include ExceptionHandler
  include CanCan::ControllerAdditions

  before_action :permitted_params, if: :devise_controller?

  def self.authentication_headers(api)
  	api.param :header, 'access-token', :string, :required, 'Access token'
    api.param :header, 'token-type',   :string, :required, 'Token type'
    api.param :header, 'client',       :string, :required, 'Client'
    api.param :header, 'expiry',       :string, :required, 'Expiry'
    api.param :header, 'uid',          :string, :required, 'Uid'
    api.response :unauthorized
    api.response :internal_server_error, "Internal Error"
  end

  def self.organization_params(api)
    api.param :form, "name", :required, :optional, "Name of Organization"
    api.param :form, "address", :required, :optional, "address of organization"
    api.param :form, "country", :required, :optional, "country of organization"
    api.param :form, "contact_person", :required, :optional, "Contact person of the organization"
    api.param :form, "email", :string, :optional, "Contact person's email"
    api.param :form, "web_site", :string, :optional, "Web site of the organization"    
  end

  def self.contacts_params(api)
    api.param :form, "name", :string, :optional, "Name of the contact"
    api.param :form, "last_name", :string, :optional, "Last name of the contact"
    api.param :form, "address", :string, :optional, "Address of contact"
    api.param :form, "country", :string, :optional, "Country of contact"
    api.param :form, "email", :string, :optional, "Email of the contact"
    api.param :form, "phone", :string, :optional, "Phone of the contact"
  end

  protected
  def permitted_params
    keys_allowed = [:name, :nickname, suscriptions_attributes: :organization_id]
    devise_parameter_sanitizer.permit(:sign_up, keys: keys_allowed)
  end
end
