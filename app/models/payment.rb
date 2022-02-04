class Payment < ApplicationRecord
  # associations
  belongs_to :origin, class_name: 'User'
  belongs_to :target, class_name: 'User'

  def self.all_payments(user)
    ids = [user.id, user.friends.pluck(:id)].flatten
    where('origin_id IN (?) OR target_id IN (?)', ids, ids).order(created_at: :desc)
  end
end
