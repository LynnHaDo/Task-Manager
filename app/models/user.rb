class User < ApplicationRecord
    validates :first_name, presence: true,
                            length: {minimum: 1}

    scope :sorted, -> { order(:last_name, :first_name) }

    has_many :task_assignments
    
    def full_name
        [first_name, last_name].join(' ')
    end

    def last_name_first
        [last_name, first_name].join(', ')
    end

    def abbrev_name
        first_initial = first_name.chars.first + "."
        [first_initial, last_name].join(' ')
    end
end
