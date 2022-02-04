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

    describe 'pagination' do
      before do
        Payment.destroy_all
        create_list(:payment, 100, origin: user)
      end

      it 'returns pagination metadata' do
        get user_feed_path(user)
        pagy_metadata = JSON.parse(response.body)['pagy']

        expect(pagy_metadata.keys).to eq(%w[count page items pages last from to prev next])
      end

      it 'returns 10 items per page' do
        get user_feed_path(user)
        pagy_metadata = JSON.parse(response.body)['pagy']

        expect(pagy_metadata['items']).to eq(10)
      end

      it 'returns pagination metadata with correct values' do
        get user_feed_path(user)
        pagy_metadata = JSON.parse(response.body)['pagy']

        expect(pagy_metadata['count']).to eq(100)
        expect(pagy_metadata['page']).to eq(1)
        expect(pagy_metadata['items']).to eq(10)
        expect(pagy_metadata['pages']).to eq(10)
        expect(pagy_metadata['last']).to eq(10)
        expect(pagy_metadata['from']).to eq(1)
        expect(pagy_metadata['to']).to eq(10)
        expect(pagy_metadata['prev']).to eq(nil)
        expect(pagy_metadata['next']).to eq(2)
      end

      it 'retuens pagination metadata with correct values when page is 2' do
        get user_feed_path(user, page: 2)
        pagy_metadata = JSON.parse(response.body)['pagy']

        expect(pagy_metadata['count']).to eq(100)
        expect(pagy_metadata['page']).to eq(2)
        expect(pagy_metadata['items']).to eq(10)
        expect(pagy_metadata['pages']).to eq(10)
        expect(pagy_metadata['last']).to eq(10)
        expect(pagy_metadata['from']).to eq(11)
        expect(pagy_metadata['to']).to eq(20)
        expect(pagy_metadata['prev']).to eq(1)
        expect(pagy_metadata['next']).to eq(3)
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
