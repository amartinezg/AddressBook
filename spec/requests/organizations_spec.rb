require 'rails_helper'

RSpec.describe 'Organizations API', type: :request do

  let!(:organizations) { create_list(:organization, 10) }
  let(:organization_id) { organizations.first.id }

  # Test suite for GET /organizations
  describe 'GET /organizations' do
    before { get '/organizations' }

    it 'returns all organizations' do
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  # Test suite for GET /organizations/:id
  describe 'GET /organizations/:id' do
    before { get "/organizations/#{organization_id}" }

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
        expect(response.body).to match(/Couldn't find Organization/)
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

    context 'When the request is valid' do
      before { post '/organizations', params: valid_params }

      it 'creates an organization' do
        expect(json['name']).to eq('New organization')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end
    
    context 'When the request is invalid' do
      before { post '/organizations', params: { name: '' } }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'resturns a validation failure message' do
        expect(response.body).to match(/Validation failed: Name can't be blank/)
      end
    end
  end

  # Test suite for PUT /organization/:id
  describe 'PUT /organizations/:id' do
    let(:valid_params) { {name: 'STRV'} }

    context 'When the request is valid' do
      before { put "/organizations/#{organization_id}", params: valid_params }

      it 'updates the record' do
        expect(response.body).to be_empty
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end
  end

  # Test suite for DELETE /organizations/:id
  describe 'DELETE /organizations/:id' do
    before { delete "/organizations/#{organization_id}" }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end

end
