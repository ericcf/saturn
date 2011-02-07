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

  def process(assignments_by_physician_id)
    offenders = { :below_minimum => [], :above_maximum => [] }
    assignments_by_physician_id.each do |physician_id, assignments|
      duration = assignments.map { |a| a.fixed_duration }.sum
      summary = { :physician_id => physician_id, :description => duration }
      offenders[:below_minimum] << summary if duration < minimum
      offenders[:above_maximum] << summary if duration > maximum
    end
    assigned_physician_ids = assignments_by_physician_id.keys
    section.member_ids.each do |physician_id|
      unless assigned_physician_ids.include?(physician_id)
        summary = { :physician_id => physician_id, :description => BigDecimal.new('0.0') }
        offenders[:below_minimum] << summary if minimum > 0.0
      end
    end
    offenders
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
