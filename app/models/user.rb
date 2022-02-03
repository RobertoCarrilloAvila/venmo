class User < ApplicationRecord
  # associations
  has_many :friendships, foreign_key: 'user_id', class_name: 'Friendship'
  has_many :friends, through: :friendships, source: :friend

  has_many :inverse_friendships, foreign_key: 'friend_id', class_name: 'Friendship'
  has_many :inverse_friends, through: :inverse_friendships, source: :user

  # validations
  validates :email, uniqueness: true
  validates :email, :name, :last_name, presence: true

  validates :balance, presence: true,
                      numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 1_000 }
end
