module V1
  class ContactsController < ApplicationController
    before_action :set_organization
    before_action :set_contact

    # GET /organizations/:organization_id/contacts
    def index
      render json: {message: "Holi"}, status: 200
    end

    # POST /organizations/:organization_id/contacts
    def create
      render json: {message: "Holi"}, status: 201
    end

    # GET /organizations/:organization_id/contacts/:id
    def show
      render json: @contact.to_json, status: 200
    end

    # PUT /organizations/:organization_id/contacts/:id
    def update
      head :no_content
    end

    # DELETE /organizations/:organization_id/contacts/:id
    def destroy
      head :no_content
    end

    private
    def set_organization
      @organization = Organization.find(params[:organization_id])
    end

    def set_contact
      @contact = Contact.find(@organization.id, params[:id])
    end
  end
end
