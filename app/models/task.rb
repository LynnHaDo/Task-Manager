class Task < ApplicationRecord
    belongs_to :category, optional: true 
    scope :sorted, -> { order(:position) }
end
