RSpec.describe ExternalPaymentService do
  subject { described_class.new(user: user, amount: amount) }

  let(:user) { create(:user, balance: 0) }
  let(:amount) { 100 }

  describe '#call' do
    it 'transfers balance' do
      expect { subject.call }.to change { user.reload.balance }.from(0).to(100)
    end

    it 'creates payment' do
      expect { subject.call }.to change(Payment, :count).from(0).to(1)
    end

    it 'creates payment with correct attributes' do
      subject.call

      payment = Payment.last

      expect(payment.origin).to eq user
      expect(payment.target).to eq user
      expect(payment.amount).to eq amount
      expect(payment.description).to eq described_class::DESCRIPTION
    end

    context 'when target has full balance' do
      let(:user) { create(:user, balance: 1000) }

      it 'raises an error' do
        expect { subject.call }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end
end
