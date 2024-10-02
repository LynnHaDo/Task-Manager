class Task < ApplicationRecord
    belongs_to :category, optional: true 
    scope :sorted, -> { order(:position) }
    validate :description_contains_no_prohibited_words
    validates_numericality_of :position, greater_than: 0

    before_validation :check_position
    before_create :log_create 
    before_update :log_update 
    after_save :log_save 
    after_commit :cleaning_reminder, if: :too_many_records 

    has_many :task_assignments

    private 
        def description_contains_no_prohibited_words
            return unless description.present?
            prohibited_words = ['banana', 'later']
            prohibited_words.each do |word|
                if (description.include?(word))
                    errors.add(:description, "Description contains #{word} (prohibited)")
                end
            end
        end

        def check_position 
            if position.blank? || position < 1 
                max = Task.maximum(:position) || 0
                self.position = max + 1
            end
        end

        def log_create
            logger.debug("Task being created: #{name} ")
        end
        
        def log_update
            logger.debug("Task being updated: #{name}")
        end
        
        def log_save
            # runs on both create & update
            logger.debug("Task was saved: #{name}")
        end
        
        def cleaning_reminder
            # This could be a placeholder for sending an email to an admin
            logger.debug("Remember to prune old tasks")
        end

        def too_many_records
            Task.count > 5
        end
end
