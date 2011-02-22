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

  def minimum_summary
    "Below weekly minimum (#{minimum})"
  end

  def maximum_summary
    "Above weekly maximum (#{maximum})"
  end

  def process(assignments_by_physician_id, ordered_physician_ids = [])
    @offenders = { :below_minimum => [], :above_maximum => [] }
    assignments_by_physician_id.each do |physician_id, assignments|
      duration = assignments.map { |a| a.fixed_duration }.sum
      summary = { :physician_id => physician_id, :description => duration }
      if minimum
        @offenders[:below_minimum] << summary if duration < minimum
      end
      if maximum
        @offenders[:above_maximum] << summary if duration > maximum
      end
    end
    assigned_physician_ids = assignments_by_physician_id.keys
    if minimum
      section.member_ids.each do |physician_id|
        unless assigned_physician_ids.include?(physician_id)
          summary = { :physician_id => physician_id, :description => BigDecimal.new('0.0') }
          @offenders[:below_minimum] << summary if minimum > 0.0
        end
      end
    end
    sort_summaries! @offenders[:below_minimum], ordered_physician_ids
    sort_summaries! @offenders[:above_maximum], ordered_physician_ids
    @offenders
  end

  def sort_summaries!(conflict_summaries, ordered_physician_ids)
    conflict_summaries.sort! do |x, y|
      ordered_physician_ids.index(x[:physician_id]) <=>
        ordered_physician_ids.index(y[:physician_id])
    end
  end

  def to_json
    return unless @offenders
    [
      minimum_offenders_to_json,
      maximum_offenders_to_json
    ].compact.join(",")
  end

  def minimum_offenders_to_json
    [
    "{",
      "\"title\":\"#{minimum_summary}\",",
      "\"conflict_by_offender_id\":",
        @offenders[:below_minimum].to_json,
    "}"
    ].join("") if minimum
  end

  def maximum_offenders_to_json
    [
    "{",
      "\"title\":\"#{maximum_summary}\",",
      "\"conflict_by_offender_id\":",
        @offenders[:above_maximum].to_json,
    "}"
    ].join("") if maximum
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
