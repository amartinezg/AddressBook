module V1
  class ContactsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_organization, :set_contact_id

    # GET /organizations/:organization_id/contacts
    def index
      contacts = Contact.all(@organization.id)
      render json: contacts.to_json, status: 200
    end

    # POST /organizations/:organization_id/contacts
    def create
      @contact = Contact.create(@organization.id, params)
      render json: @contact, status: 201
    end

    # GET /organizations/:organization_id/contacts/:id
    def show
      @contact = Contact.find(@organization.id, @content_id)
      render json: @contact.to_json, status: 200
    end

    # PUT /organizations/:organization_id/contacts/:id
    def update
      params.merge!("organization_id" => @organization.id)
      Contact.new(params).update
      head :no_content
    end

    # DELETE /organizations/:organization_id/contacts/:id
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
