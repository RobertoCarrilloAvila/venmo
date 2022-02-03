RSpec.describe User, type: :model do
  describe 'validations' do
    subject { build :user }

    it { is_expected.to validate_uniqueness_of(:email) }
  end

  describe 'associations' do
    subject { create :user }

    it { is_expected.to have_many(:friendships) }
    it { is_expected.to have_many(:friends).through(:friendships) }

    it { is_expected.to have_many(:inverse_friendships) }
    it { is_expected.to have_many(:inverse_friends).through(:inverse_friendships) }
  end
end