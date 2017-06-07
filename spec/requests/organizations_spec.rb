require 'rails_helper'

RSpec.describe 'Organizations API', type: :request do

  let!(:organizations) { create_list(:organization, 9) }
  let(:organization_id) { organizations.first.id }
  let(:valid_user) { create(:admin_user) }
  let(:regular_user) { create(:regular_user) }

  # Test suite for GET /organizations
  describe 'GET /organizations' do
    context "When the user is logged in" do
      before { get '/organizations', headers: api_authentication(valid_user) }
      it 'returns all organizations' do
        expect(json).not_to be_empty
        expect(json.size).to eq(10)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context "When the user is logged in as regular user" do
      before { get '/organizations', headers: api_authentication(regular_user) }
      it 'returns all organizations' do
        expect(json).not_to be_empty
        expect(json.size).to eq(10)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context "When the user is not logged in" do
      before { get '/organizations' }

      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end
    end
  end

  # Test suite for GET /organizations/:id
  describe 'GET /organizations/:id' do
    context "When the user is logged in" do
      before { get "/organizations/#{organization_id}", headers: api_authentication(valid_user) }

      context 'When the record exists' do
        it 'returns the organization' do
          expect(json).not_to be_empty
          expect(json['id']).to eq(organization_id)
        end

        it 'returns status code 200' do
          expect(response).to have_http_status(200)
        end
      end

      context 'When the record does not exist' do
        let(:organization_id) { 500 }

        it 'returns status code 404' do
          expect(response).to have_http_status(404)
        end

        it 'returns not found message' do
          expect(response.body).to match(/Organization does not exist/)
        end
      end
    end

    context "When the user is logged in as regular user" do
      before { get "/organizations/#{organization_id}", headers: api_authentication(regular_user) }

      context 'When the record exists' do
        it 'returns the organization' do
          expect(json).not_to be_empty
          expect(json['id']).to eq(organization_id)
        end

        it 'returns status code 200' do
          expect(response).to have_http_status(200)
        end
      end

      context 'When the record does not exist' do
        let(:organization_id) { 500 }

        it 'returns status code 404' do
          expect(response).to have_http_status(404)
        end

        it 'returns not found message' do
          expect(response.body).to match(/Organization does not exist/)
        end
      end
    end

    context "When the user is not logged in" do
      before { get "/organizations/#{organization_id}" }

      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end
    end

  end

  # Test suite for POST /organizations
  describe 'POST /organizations' do
    let(:valid_params) {{name: 'New organization',
                        address: '5th Av',
                        country: 'USA',
                        contact_person: 'Andres Martinez',
                        email: 'amartinez@gmail.com'}}

    context "When the user is logged in" do
      context 'When the request is valid' do
        before do
          post '/organizations', params: valid_params, headers: api_authentication(valid_user)
        end

        it 'creates an organization' do
          expect(json['name']).to eq('New organization')
        end

        it 'returns status code 201' do
          expect(response).to have_http_status(201)
        end
      end

      context 'When the request is invalid' do
        before { post '/organizations', params: { name: '' }, headers: api_authentication(valid_user) }

        it 'returns status code 422' do
          expect(response).to have_http_status(422)
        end

        it 'returns a validation failure message' do
          expect(response.body).to match(/Validation failed: Name can't be blank/)
        end
      end
    end

    context "When the user is logged in as regular user" do
      context 'When the request is valid' do
        before do
          post '/organizations', params: valid_params, headers: api_authentication(regular_user)
        end

        it 'returns status code 403' do
          expect(response).to have_http_status(403)
        end
      end

      context 'When the request is invalid' do
        before { post '/organizations', params: { name: '' }, headers: api_authentication(regular_user) }

        it 'returns status code 403' do
          expect(response).to have_http_status(403)
        end
      end
    end
  end

  # Test suite for PUT /organization/:id
  describe 'PUT /organizations/:id' do
    let(:valid_params) { {name: 'STRV'} }

    context 'When the user is logged in' do
      context 'When the request is valid' do
        before { put "/organizations/#{organization_id}", params: valid_params, headers: api_authentication(valid_user) }

        it 'updates the record' do
          expect(response.body).to be_empty
        end

        it 'returns status code 204' do
          expect(response).to have_http_status(204)
        end
      end
    end

    context 'When the user is logged in as regular user' do
      context 'When the request is valid' do
        before { put "/organizations/#{organization_id}", params: valid_params, headers: api_authentication(regular_user) }

        it 'returns status code 403' do
          expect(response).to have_http_status(403)
        end
      end
    end

    context 'When the user is not logged in' do
      before { put "/organizations/#{organization_id}", params: valid_params }

      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end
    end
  end

  # Test suite for DELETE /organizations/:id
  describe 'DELETE /organizations/:id' do
    context "When the user is logged in" do
      before { delete "/organizations/#{organization_id}", headers: api_authentication(valid_user) }

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end

    context "When the user is logged in as regular user" do
      before { delete "/organizations/#{organization_id}", headers: api_authentication(regular_user) }

      it 'returns status code 403' do
        expect(response).to have_http_status(403)
      end
    end

    context "When the user is not logged in" do
      before { delete "/organizations/#{organization_id}" }

      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end
    end
  end

end
