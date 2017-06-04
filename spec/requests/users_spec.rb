require 'rails_helper'

RSpec.describe "Users API", type: :request do

  # Test suite for POST /auth/
  describe "POST /auth" do
    let!(:organizations) { create_list(:organization, 2) }
    let(:params){{email: "user@strv.com",
                  password: "12345678",
                  password_confirmation: "12345678",
                  suscriptions_attributes: [
                    {organization_id: organizations.first.id},
                    {organization_id: organizations.last.id}
                  ]}}
    before { post '/auth', params: params }

    it "creates an user associated with some organizations" do
      user = User.find(json['data']['id'])
      organizations = user.organizations
      expect(organizations.count).to eq(2)
      expect(organizations.pluck(:id)).to eq(Organization.pluck(:id))
    end

    it "returns status code 200" do
      expect(response).to have_http_status(200)
    end
  end

  # Test suite for POST /auth/sign_in/
  describe "POST /auth/sign_in" do
    let(:user){ create(:user) }
    let(:params){ { email: "#{user.email}", password: "#{user.password}" }}
    before { post '/auth/sign_in', params: params }

    it "returns an access token header" do
      expect(response.headers.keys.include?("access-token")).to be_truthy
    end

    it "returns status code 200" do
      expect(response).to have_http_status(200)
    end
  end
end
