class Payment < ApplicationRecord
  # associations
  belongs_to :origin, class_name: 'User'
  belongs_to :target, class_name: 'User'
end
