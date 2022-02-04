RSpec.describe User::PaymentsController, type: :request do
  describe 'GET #index' do
    let(:user)       { create(:user) }
    let(:friend)     { create(:user) }
    let(:not_friend) { create(:user) }

    before do
      user.friends << friend
      user.payments_sent.create(amount: 10, target: friend)
      create(:payment, amount: 10, origin: friend, target: not_friend)

      create_list(:payment, 20)
    end

    it 'returns http success' do
      get user_feed_path(user)
      expect(response).to have_http_status(:success)
    end

    it 'returns all payments for the user and its friends' do
      get user_feed_path(user)
      feeds = JSON.parse(response.body)['feeds']

      expect(feeds.count).to eq(2)
    end

    it 'returns all payments in reverse chronological order' do
      get user_feed_path(user)
      feeds = JSON.parse(response.body)['feeds']

      expect(feeds.first['created_at']).to be > feeds.last['created_at']
    end

    it 'return right fields' do
      get user_feed_path(user)
      feeds = JSON.parse(response.body)['feeds']
      
      expect(feeds.first.keys).to eq(%w(id origin target amount description created_at))
    end

    context 'when user does not exist' do
      before { get user_feed_path(id: 0) }

      it 'returns http not found' do
        expect(response).to have_http_status(:not_found)
      end

      it 'returns error message' do
        expect(response.body).to eq({ error: 'Record not found' }.to_json)
      end
    end
  end
end