class User < ApplicationRecord
  # validations
  validates :email, uniqueness: true
  validates :email, :name, :last_name, presence: true
end
