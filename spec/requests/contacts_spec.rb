require 'rails_helper'

RSpec.describe 'Contacts API', type: :request do

  let(:organization) { create(:organization) }
  let(:valid_user) { create(:admin_user) }
  let(:regular_user) { create(:regular_user) }

  # Test suite for GET /organizations/:organization_id/contacts
  describe 'GET /organizations/:organization_id/contacts' do
    let(:uri_template) { Addressable::Template.new "#{FirebaseWrapper::BASE_URI}{id}.json" }
    before { stub_request(:any, uri_template) }
    before { allow_any_instance_of(Firebase::Response).to receive_messages(:body => firebase_valid_response) }

    context "When the user is logged in" do
      before { get "/organizations/#{organization.id}/contacts", headers: api_authentication(valid_user) }
      it 'returns all contacts given a organization'  do
        expect(json).not_to be_empty
        expect(json.first["id"]).to eq("-KlxNNEaAPS4G6xVxijL")
        expect(json.size).to eq(1)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context "When the user is logged in as regular user and belongs to the organization" do
      before { get "/organizations/#{regular_user.organizations.first.id}/contacts", headers: api_authentication(regular_user) }
      it 'returns all organizations' do
        expect(json).not_to be_empty
        expect(json.first["id"]).to eq("-KlxNNEaAPS4G6xVxijL")
        expect(json.size).to eq(1)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context "When the user is logged in as regular user and does not belong to the organization" do
      before { get "/organizations/#{organization.id}/contacts", headers: api_authentication(regular_user) }

      it 'returns error message' do
        expect(json["message"]).to match(/You are not authorized to access this page./)
      end

      it 'returns status code 403' do
        expect(response).to have_http_status(403)
      end
    end

    context "When the user is not logged in" do
      before { get "/organizations/#{organization.id}/contacts" }

      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end
    end
  end

  # Test suite for GET /organizations/:organization_id/contacts/:id
  describe 'GET /organizations/:organization_id/contacts/:id' do
    let(:uri_template) { Addressable::Template.new "#{FirebaseWrapper::BASE_URI}{id}.json{?child}" }
    before { stub_request(:any, uri_template) }
    
    context "When the user is logged in" do
      context 'When the record exists' do
        before { allow_any_instance_of(Firebase::Response).to receive_messages(:body => firebase_valid_response) }
        before { get "/organizations/#{organization.id}/contacts/-KlxNNEaAPS4G6xVxijL", headers: api_authentication(valid_user) }

        it 'returns the contact' do
          expect(json).not_to be_empty
          expect(json['id']).to eq("-KlxNNEaAPS4G6xVxijL")
        end

        it 'returns status code 200' do
          expect(response).to have_http_status(200)
        end
      end

      context 'When the record does not exist' do
        before { allow_any_instance_of(Firebase::Response).to receive_messages(:body => nil) }
        before { get "/organizations/#{organization.id}/contacts/dsfkksd", headers: api_authentication(valid_user) }
        it 'returns status code 404' do
          expect(response).to have_http_status(404)
        end

        it 'returns not found message' do
          expect(response.body).to match(/Contact not found/)
        end
      end
    end

    context "When the user is logged in as regular user and belongs to the organization" do
      context 'When the record exists' do
        before { allow_any_instance_of(Firebase::Response).to receive_messages(:body => firebase_valid_response) }
        before { get "/organizations/#{regular_user.organizations.first.id}/contacts/-KlxNNEaAPS4G6xVxijL", headers: api_authentication(regular_user) }

        it 'returns the contact' do
          expect(json).not_to be_empty
          expect(json['id']).to eq("-KlxNNEaAPS4G6xVxijL")
        end

        it 'returns status code 200' do
          expect(response).to have_http_status(200)
        end
      end

      context 'When the record does not exist' do
        before { allow_any_instance_of(Firebase::Response).to receive_messages(:body => nil) }
        before { get "/organizations/#{regular_user.organizations.first.id}/contacts/-KlxNNEaAPS4G6xVxijL", headers: api_authentication(regular_user) }
        it 'returns status code 404' do
          expect(response).to have_http_status(404)
        end

        it 'returns not found message' do
          expect(response.body).to match(/Contact not found/)
        end
      end
    end

    context "When the user is logged in as regular user and does not belong to the organization" do
      before { get "/organizations/#{organization.id}/contacts/:id", headers: api_authentication(regular_user) }

      it 'returns error message' do
        expect(json["message"]).to match(/You are not authorized to access this page./)
      end

      it 'returns status code 403' do
        expect(response).to have_http_status(403)
      end
    end    

    context "When the user is not logged in" do
      before { get "/organizations/#{organization.id}/contacts/:id" }

      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end
    end
  end  

  # Test suite for POST /organizations/:organization_id/contacts
  describe 'POST /organizations/:organization_id/contacts' do
    let(:valid_params) {{name: 'Andres',
                        last_name: 'Martinez',
                        country: 'Colombia',
                        phone: '51943545',
                        email: 'amartinez@gmail.com'}}
    let(:uri_template) { Addressable::Template.new "#{FirebaseWrapper::BASE_URI}{id}.json" }
    before { stub_request(:any, uri_template) }                        
    before { allow_any_instance_of(Firebase::Response).to receive_messages(:body => {"id" => "-KlxNNEaAPS4G6xVxijL"}) }

    context "When the user is logged in" do
      context 'When the request is valid' do
        before do
          post "/organizations/#{organization.id}/contacts", params: valid_params, headers: api_authentication(valid_user)
        end

        it 'creates a contact' do
          expect(json['name']).to eq('Andres')
        end

        it 'returns status code 201' do
          expect(response).to have_http_status(201)
        end
      end

      context 'When the request is invalid' do
        before { post "/organizations/#{organization.id}/contacts", params: {}, headers: api_authentication(valid_user) }

        it 'returns status code 422' do
          expect(response).to have_http_status(422)
        end

        it 'returns a validation failure message' do
          expect(response.body).to match(/There are not valid data to create contact/)
        end
      end
    end

    context "When the user is logged in as regular user and belongs to the organization" do
      context 'When the request is valid' do
        before do
          post "/organizations/#{regular_user.organizations.first.id}/contacts", 
                  params: valid_params, headers: api_authentication(regular_user)
        end

        it 'creates a contact' do
          expect(json['name']).to eq('Andres')
        end

        it 'returns status code 201' do
          expect(response).to have_http_status(201)
        end
      end

      context 'When the request is invalid' do
        before { post "/organizations/#{regular_user.organizations.first.id}/contacts", 
                  params: {}, headers: api_authentication(regular_user) }

        it 'returns status code 422' do
          expect(response).to have_http_status(422)
        end

        it 'returns a validation failure message' do
          expect(response.body).to match(/There are not valid data to create contact/)
        end
      end
    end

    context "When the user is logged in as regular user and does not belong to the organization" do
      context 'When the request is valid' do
        before do
          post "/organizations/#{organization.id}/contacts", 
                  params: valid_params, headers: api_authentication(regular_user)
        end

        it 'returns error message' do
          expect(json["message"]).to match(/You are not authorized to access this page./)
        end

        it 'returns status code 403' do
          expect(response).to have_http_status(403)
        end
      end

      context 'When the request is invalid' do
        before { post "/organizations/#{organization.id}/contacts", 
                  params: {}, headers: api_authentication(regular_user) }

        it 'returns error message' do
          expect(json["message"]).to match(/You are not authorized to access this page./)
        end

        it 'returns status code 403' do
          expect(response).to have_http_status(403)
        end
      end
    end    
  end

  # Test suite for PUT /organizations/:organization_id/contacts/:id
  describe 'PUT /organizations/:organization_id/contacts/:id' do
    let(:uri_template) { Addressable::Template.new "#{FirebaseWrapper::BASE_URI}{id}.json{?child}" }
    let(:patch_template) { Addressable::Template.new "#{FirebaseWrapper::BASE_URI}{organization_id}/{id}.json" }
    before { stub_request(:any, uri_template) }
    before { stub_request(:patch, patch_template) }
    before { allow_any_instance_of(Firebase::Response).to receive_messages(:body => firebase_valid_response) }

    let(:valid_params) { {name: 'STRV'} }

    context 'When the user is logged in' do
      context 'When the request is valid' do
        before { put "/organizations/#{organization.id}/contacts/-KlxNNEaAPS4G6xVxijL", 
                      params: valid_params, headers: api_authentication(valid_user) }

        it 'updates the record' do
          expect(response.body).to be_empty
        end

        it 'returns status code 204' do
          expect(response).to have_http_status(204)
        end
      end
    end

    context 'When the user is logged in as regular user and does not belong to the organization' do
      context 'When the request is valid' do
        before { put "/organizations/#{organization.id}/contacts/-KlxNNEaAPS4G6xVxijL", 
                      params: valid_params, headers: api_authentication(regular_user) }

        it 'returns status code 403' do
          expect(response).to have_http_status(403)
        end
      end
    end

    context 'When the user is not logged in' do
      before { put "/organizations/#{organization.id}", params: valid_params }

      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end
    end
  end    

  # Test suite for DELETE /organizations/:organization_id/contacts/:id
  describe 'DELETE /organizations/:organization_id/contacts/:id' do
    let(:uri_template) { Addressable::Template.new "#{FirebaseWrapper::BASE_URI}{id}.json{?child}" }
    let(:delete_template) { Addressable::Template.new "#{FirebaseWrapper::BASE_URI}{organization_id}/{id}.json" }
    before { stub_request(:any, uri_template) }
    before { stub_request(:delete, delete_template) }
    before { allow_any_instance_of(Firebase::Response).to receive_messages(:body => firebase_valid_response) }

    context "When the user is logged in" do
      before { delete "/organizations/#{organization.id}/contacts/-KlxNNEaAPS4G6xVxijL", headers: api_authentication(valid_user) }

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end

    context "When the user is logged in as regular user and belongs to the organization" do
      before { delete "/organizations/#{regular_user.organizations.first.id}/contacts/-KlxNNEaAPS4G6xVxijL", headers: api_authentication(regular_user) }

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end

    context "When the user is logged in as regular user and does not belong to the organization" do
      before { delete "/organizations/#{organization.id}/contacts/-KlxNNEaAPS4G6xVxijL", headers: api_authentication(regular_user) }

      it 'returns status code 403' do
        expect(response).to have_http_status(403)
      end
    end

    context "When the user is not logged in" do
      before { delete "/organizations/#{organization.id}" }

      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end
    end
  end

end