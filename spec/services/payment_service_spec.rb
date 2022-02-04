RSpec.describe PaymentService do
  let(:user)        { create :user, balance: 200 }
  let(:friend)      { create :user, balance: 200 }
  let(:amount)      { 100 }
  let(:description) { 'test description' }

  subject do
    described_class.new(
      user_id: user.id,
      friend_id: friend.id,
      amount: amount,
      description: description
    )
  end

  before do
    user.friends << friend
  end

  describe '#call' do
    it 'transfers balance' do
      expect { subject.call }.to change { user.reload.balance }.from(200).to(100)
    end

    it 'creates payment' do
      expect { subject.call }.to change { Payment.count }.from(0).to(1)
    end

    it 'creates payment with correct attributes' do
      subject.call

      payment = Payment.last

      expect(payment.origin).to eq user
      expect(payment.target).to eq friend
      expect(payment.amount).to eq amount
      expect(payment.description).to eq description
    end

    context 'when origin has insufficient balance' do
      let(:user) { create :user, balance: 10 }

      it 'raises an error' do
        expect { subject.call }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context 'when target has full balance' do
      let(:friend) { create :user, balance: 1000 }

      it 'raises an error' do
        expect { subject.call }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context 'when the target is not a friend' do
      let(:friend) { create :user }

      before { user.friends.delete(friend) }

      it 'raises an error' do
        expect { subject.call }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'when the origin balance is zero' do
      let(:user) { create :user, balance: 0 }

      it 'raises an error' do
        expect { subject.call }.to change { Payment.count }.from(0).to(2)
      end
    end
  end
end