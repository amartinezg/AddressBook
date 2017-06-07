module V1
  class ContactsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_organization, :set_contact_id
    swagger_controller :contacts, "Contacts Management"

    swagger_api :index do |api|
      summary "Fetches all contacts"
      ApplicationController::authentication_headers(api)
      notes "Regular users can list contacts if they belong to the organization, do not forget authentication headers"
      response :unauthorized
      response :not_acceptable, "The request you made is not acceptable"
      response :requested_range_not_satisfiable
    end
    def index
      contacts = Contact.all(@organization.id)
      render json: contacts.to_json, status: 200
    end

    swagger_api :create do |api|
      summary "To create a contacts"
      ApplicationController::contacts_params(api)
      ApplicationController::authentication_headers(api)
      notes "Regular users can create contacts if they belong to the organization, do not forget authentication headers"
      response :created
    end
    def create
      @contact = Contact.create(@organization.id, params)
      render json: @contact, status: 201
    end

    swagger_api :show do |api|
      summary "Fetches a single contact"
      ApplicationController::authentication_headers(api)
      notes "Reglar users can show contacts if they belong to the organization, do not forget authentication headers"
      param :path, :id, :integer, :required, "Organization id"
      response :ok
      response :not_found
    end
    def show
      @contact = Contact.find(@organization.id, @content_id)
      render json: @contact.to_json, status: 200
    end

    swagger_api :update do |api|
      summary "To update a contact"
      ApplicationController::authentication_headers(api)
      ApplicationController::contacts_params(api)
      notes "Reglar users can update contacts if they belong to the organization, do not forget authentication headers"
    end
    def update
      params.merge!("organization_id" => @organization.id)
      Contact.new(params).update
      head :no_content
    end

    swagger_api :destroy do |api|
      summary "To destroy a contact"
      ApplicationController::authentication_headers(api)
      notes "Regular users can delete contacts if they belong to the organization, do not forget authentication headers"
    end
    def destroy
      params = {"organization_id" => @organization.id, "id" => @content_id}
      Contact.new(params).destroy
      head :no_content
    end

    private
    def set_organization
      organization_id = params[:organization_id]
      @organization = current_user.admin? ? Organization.find(organization_id) :
        current_user.organizations.where(id: params[:organization_id]).first

      raise CanCan::AccessDenied unless @organization
    end

    def set_contact_id
      @content_id = params[:id] 
    end

  end
end
