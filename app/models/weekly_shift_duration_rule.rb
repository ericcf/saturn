class WeeklyShiftDurationRule < ActiveRecord::Base

  attr_accessible :section, :minimum, :maximum

  belongs_to :section
  
  validates :section, :presence => true
  validates_associated :section
  validates :minimum, :maximum, :numericality => {
    :greater_than_or_equal_to => 0.0,
    :less_than_or_equal_to => 999.9,
    :allow_nil => true
  }
  validate :maximum_greater_than_or_equal_to_minimum?

  def process(assignments_by_physician)
    group_below_minimum = {}
    group_above_maximum = {}
    assignments_by_physician.each do |physician, assignments|
      duration = assignments.map { |a| a.fixed_duration }.sum
      group_below_minimum[physician] = duration if duration < minimum
      group_above_maximum[physician] = duration if duration > maximum
    end
    section.members.each do |member|
      unless assignments_by_physician.keys.include?(member)
        group_below_minimum[member] = 0.0 if minimum > 0.0
      end
    end
    return group_below_minimum, group_above_maximum
  end

  private

  def maximum_greater_than_or_equal_to_minimum?
    unless self[:maximum].nil? or self[:minimum].nil?
      unless self[:maximum] >= self[:minimum]
        errors.add(:maximum, "must be greater than the minimum")
      end
    end
  end
end
