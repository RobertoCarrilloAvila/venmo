RSpec.describe User, type: :model do
  describe 'validations' do
    subject { build :user }

    it { is_expected.to validate_uniqueness_of(:email) }
    it { is_expected.to validate_presence_of(:balance) }

    it {
      expect(subject).to validate_numericality_of(:balance)
        .is_greater_than_or_equal_to(0)
        .is_less_than_or_equal_to(1_000)
    }
  end

  describe 'associations' do
    subject { create :user }

    it { is_expected.to have_many(:friendships) }
    it { is_expected.to have_many(:friends).through(:friendships) }

    it { is_expected.to have_many(:inverse_friendships) }
    it { is_expected.to have_many(:inverse_friends).through(:inverse_friendships) }

    it { is_expected.to have_many(:payments_sent) }
    it { is_expected.to have_many(:payments_received) }
  end

  describe '#withdraw' do
    subject { create :user, balance: 100 }

    it 'decreases balance' do
      expect { subject.withdraw(100) }.to change { subject.balance }.from(100).to(0)
    end

    context 'when balance is less than amount' do
      subject { create :user, balance: 10 }

      it 'raises an error' do
        expect { subject.withdraw(100) }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end

  describe '#deposit' do
    subject { create :user, balance: 100 }

    it 'increases balance' do
      expect { subject.deposit(100) }.to change { subject.balance }.from(100).to(200)
    end

    context 'when balance is more than amount' do
      subject { create :user, balance: 1000 }

      it 'raises an error' do
        expect { subject.deposit(100) }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end
end
