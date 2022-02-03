class Payment < ApplicationRecord
  # associations
  belongs_to :origin, foreign_key: 'origin_id', class_name: 'User'
  belongs_to :target, foreign_key: 'target_id', class_name: 'User'
end
