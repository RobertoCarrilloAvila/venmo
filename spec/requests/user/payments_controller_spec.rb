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

    it 'return right fields' do
      get user_feed_path(user)
      feeds = JSON.parse(response.body)['feeds']

      expect(feeds.first.keys).to eq(%w[title description])
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

  describe 'POST #create' do
    let(:user)        { create(:user, balance: 200) }
    let(:friend)      { create(:user, balance: 200) }
    let(:amount)      { 100 }
    let(:description) { 'test description' }

    let(:params) do
      {
        payment: {
          friend_id: friend.id,
          amount: amount,
          description: description
        }
      }
    end

    before do
      user.friends << friend
    end

    it 'returns http success' do
      post user_payment_path(user), params: params
      expect(response).to have_http_status(:created)
    end

    it 'returns error message when origin has insufficient balance' do
      user.update(balance: 10)
      post user_payment_path(user), params: params

      expect(response.body).to include('must be greater than or equal to 0')
    end

    it 'returns error message when target has full balance' do
      friend.update(balance: 1000)
      post user_payment_path(user), params: params

      expect(response.body).to include('must be less than or equal to 1000')
    end

    context 'when the target is not a friend' do
      let(:friend) { create(:user) }

      before { user.friends.delete(friend) }

      it 'raises an error' do
        post user_payment_path(user), params: params

        expect(response.body).to include('Record not found')
      end
    end

    context 'when origin has balance zero' do
      let(:user) { create(:user, balance: 0) }

      it 'raises an error' do
        post user_payment_path(user), params: params
        expect(response).to have_http_status(:created)
      end
    end
  end
end
