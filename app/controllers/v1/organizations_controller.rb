module V1
  class OrganizationsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_organization, only: [:show, :update, :destroy]
    load_and_authorize_resource
    swagger_controller :organizations, "Organization Management"

    swagger_api :index do |api|
      summary "Fetches all organizations"
      ApplicationController::authentication_headers(api)
      notes "Admin and regular users can list organizations, do not forget authentication headers"
      response :unauthorized
      response :not_acceptable, "The request you made is not acceptable"
      response :requested_range_not_satisfiable
    end
    def index
      @organizations = Organization.all
      render json: @organizations, status: 200
    end

    swagger_api :create do |api|
      summary "To create an organization"
      ApplicationController::organization_params(api)
      ApplicationController::authentication_headers(api)
      notes "Only admin users can create organizations, do not forget authentication headers"
      response :created
    end
    def create
      @organization = Organization.create!(organization_params)
      render json: @organization, status: 201 
    end

    swagger_api :show do |api|
      summary "Fetches a single Organization"
      ApplicationController::authentication_headers(api)
      notes "Admin and regular users can show organizations, do not forget authentication headers"
      param :path, :id, :integer, :required, "Organization id"
      response :ok
      response :not_found
    end
    def show
      render json: @organization, status: 200
    end

    swagger_api :update do |api|
      summary "To update an organization"
      ApplicationController::authentication_headers(api)
      ApplicationController::organization_params(api)
      notes "Only admin users can update organizations, do not forget authentication headers"
    end
    def update
      @organization.update(organization_params)
      head :no_content
    end

    swagger_api :destroy do |api|
      summary "To destroy an organization"
      ApplicationController::authentication_headers(api)
      notes "Only admin users can destroy organizations, do not forget authentication headers"
    end
    def destroy
      @organization.destroy
      head :no_content
    end

    private
    def organization_params
      params.permit(:name, :address, :country, :contact_person, :email, :web_site)
    end

    def set_organization
      @organization = Organization.find(params[:id])
    end
  end  
end
