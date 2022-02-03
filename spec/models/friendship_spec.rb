RSpec.describe Friendship, type: :model do
  describe 'validations' do
    subject { create :friendship }

    it { is_expected.to validate_uniqueness_of(:user).scoped_to(:friend_id).case_insensitive }
    it { is_expected.to validate_exclusion_of(:friend).in_array([subject.user]) }
  end

  describe 'associations' do
    subject { create :friendship }

    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:friend) }
  end
end