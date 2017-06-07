module V1
  class OrganizationsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_organization, only: [:show, :update, :destroy]
    load_and_authorize_resource

    # GET /organizations
    def index
      @organizations = Organization.all
      render json: @organizations, status: 200
    end

    # POST /organizations
    def create
      @organization = Organization.create!(organization_params)
      render json: @organization, status: 201 
    end

    # GET /organizations/:uuid
    def show
      render json: @organization, status: 200
    end

    # PUT /organizations/:uuid
    def update
      @organization.update(organization_params)
      head :no_content
    end

    # DELETE /organizations/:uuid
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
