require 'rails_helper'

describe 'Profile API' do
  describe 'GET /me' do
    it_behaves_like "API Authenticable"

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      before { do_request access_token: access_token.token }

      it 'returns 201 status code' do
        expect(response).to be_success
      end

      %w(id email created_at updated_at admin).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(me.send(attr.to_sym).to_json).at_path("user/#{attr}")
        end
      end

      %w(password encrypted_password).each do |attr|
        it "does not contain #{attr}" do
          expect(response.body).to_not have_json_path("user/#{attr}")
        end
      end
    end
    def do_request(options = {})
      get '/api/v1/profiles/me', { format: :json }.merge(options)
    end
  end

  describe 'GET /others' do
    it_behaves_like "API Authenticable"

    context 'authorized' do
      let(:me) { create(:user) }
      let!(:others) { create_list(:user, 3) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      before { do_request access_token: access_token.token }

      it 'returns 201 status code' do
        expect(response).to be_success
      end

      it 'contains others users' do
        expect(response.body).to be_json_eql(others.to_json).at_path("users")
      end

      it 'not contains me' do
        expect(response.body).to_not include_json(me.to_json).at_path("users")
      end
    end
    def do_request(options = {})
      get '/api/v1/profiles/others', { format: :json }.merge(options)
    end
  end
end
