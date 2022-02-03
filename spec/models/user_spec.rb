RSpec.describe User, type: :model do
  describe 'validations' do
    subject { build :user }

    it { is_expected.to validate_uniqueness_of(:email) }
    it { is_expected.to validate_presence_of(:balance) }
    it { is_expected.to validate_numericality_of(:balance)
                        .is_greater_than_or_equal_to(0)
                        .is_less_than_or_equal_to(1_000) }
  end

  describe 'associations' do
    subject { create :user }

    it { is_expected.to have_many(:friendships) }
    it { is_expected.to have_many(:friends).through(:friendships) }

    it { is_expected.to have_many(:inverse_friendships) }
    it { is_expected.to have_many(:inverse_friends).through(:inverse_friendships) }
  end
end