class PhysicianSchedule
  include ActiveModel::Validations

  attr_writer :start_date, :number_of_days
  attr_accessor :physician

  validates :start_date, :number_of_days, :physician, :presence => true

  def initialize(attributes = {})
    return unless attributes.respond_to?(:each)
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def dates
    @dates ||= (@start_date..@start_date+@number_of_days-1).to_a
  end

  def assignments
    @assignments ||= physician.assignments.
      includes(:weekly_schedule, :shift).
      published.
      find_all_by_date(dates)
  end

  def assignments_for_section_and_date(section, date)
    @assignments_by_section ||= assignments.group_by do |assignment|
      assignment.weekly_schedule.section
    end
    section_assignments = @assignments_by_section[section] || []
    section_assignments.group_by(&:date)[date]
  end

end
