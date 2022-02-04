class User < ApplicationRecord
  # associations
  has_many :friendships, class_name: 'Friendship'
  has_many :friends, through: :friendships, source: :friend

  has_many :inverse_friendships, foreign_key: 'friend_id', class_name: 'Friendship'
  has_many :inverse_friends, through: :inverse_friendships, source: :user

  has_many :payments_sent, foreign_key: 'origin_id', class_name: 'Payment'
  has_many :payments_received, foreign_key: 'target_id', class_name: 'Payment'

  # validations
  validates :email, uniqueness: true
  validates :email, :name, :last_name, :balance, presence: true

  validates :balance, presence: true,
                      numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 1_000 }
end
