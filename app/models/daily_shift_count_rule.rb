class DailyShiftCountRule < ActiveRecord::Base

  attr_accessible :section, :shift_tag, :shift_tag_id, :maximum

  belongs_to :section
  belongs_to :shift_tag

  validates :shift_tag, :presence => true
  validates :shift_tag_id, :uniqueness => true
  validates_associated :section, :shift_tag
  validates :maximum, :numericality => {
    :greater_than_or_equal_to => 0,
    :less_than_or_equal_to => 99,
    :allow_nil => true
  }

  def process(assignments_by_physician)
    group_over_maximum = []
    assignments_by_physician.each do |physician, assignments|
      counts_by_date = assignments.each_with_object({}) do |assignment, hash|
        if shift_tag.shift_ids.include? assignment.shift_id
          hash[assignment.date] ||= 0
          hash[assignment.date] += 1
        end
      end
      counts_by_date.each do |date, count|
        group_over_maximum << [physician, count, date] if count > maximum
      end
    end
    group_over_maximum
  end
end
