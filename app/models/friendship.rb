class Friendship < ApplicationRecord
  # associations
  belongs_to :user, class_name: 'User'
  belongs_to :friend, class_name: 'User'

  # validations
  validates :user, uniqueness: { scope: :friend_id }
  validates :friend, exclusion: { in: ->(friendship) { [friendship.user] } }
end
