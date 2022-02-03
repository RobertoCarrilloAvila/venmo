class Friendship < ApplicationRecord
  # associations
  belongs_to :user, foreign_key: 'user_id', class_name: 'User'
  belongs_to :friend, foreign_key: 'friend_id', class_name: 'User'

  # validations
  validates_uniqueness_of :user, scope: :friend_id
  validates_exclusion_of :friend, in: ->(friendship) { [friendship.user] }
end
