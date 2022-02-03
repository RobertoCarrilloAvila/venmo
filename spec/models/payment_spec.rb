RSpec.describe Payment, type: :model do
  describe 'associations' do
    subject { create :payment }

    it { is_expected.to belong_to(:origin) }
    it { is_expected.to belong_to(:target) }
  end
end