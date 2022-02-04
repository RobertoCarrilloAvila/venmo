RSpec.describe Payment, type: :model do
  describe 'associations' do
    subject { create :payment }

    it { is_expected.to belong_to(:origin) }
    it { is_expected.to belong_to(:target) }
  end

  describe '#all_payments' do
    subject { described_class.all_payments(user) }

    let(:user) { create :user }
    let(:friend) { create :user }
    let(:not_friend) { create :user }

    before do
      user.friends << friend
      user.payments_sent.create(amount: 10, target: friend)
      create(:payment, amount: 10, origin: friend, target: not_friend)

      create_list(:payment, 20)
    end

    it 'returns all payments for the user and its friends' do
      expect(subject.count).to eq(2)
    end

    it 'return only user and friends payments' do
      expect(subject.pluck(:origin_id, :target_id)).to all(include(user.id).or(include(friend.id)))
    end
  end
end
