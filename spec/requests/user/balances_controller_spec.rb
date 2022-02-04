RSpec.describe User::BalancesController, type: :request do
  describe 'GET #show' do
    let(:user) { create(:user, balance: 100) }

    before { get user_balance_path(user) }

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'returns user balance' do
      expect(response.body).to eq({ user: { balance: 100 } }.to_json)
    end

    context 'when user does not exist' do
      before { get user_balance_path(id: 0) }

      it 'returns http not found' do
        expect(response).to have_http_status(:not_found)
      end

      it 'returns error message' do
        expect(response.body).to eq({ error: 'Record not found' }.to_json)
      end
    end
  end
end
