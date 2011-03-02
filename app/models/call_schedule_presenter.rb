require 'tables'

class CallSchedulePresenter
  include ActiveModel::Validations

  attr_accessor :dates

  validates :dates, :presence => true

  def initialize(attributes = {})
    return unless attributes.respond_to?(:each)
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def summaries_by_section_id_shift_id_and_date(section_id, shift_id, date)
    assignments = mapped_assignments[[section_id, shift_id, date]] || []
    assignments.map do |assignment|
      {
        :text => physicians_by_id[assignment.physician_id].short_name,
        :note => assignment.public_note,
        :duration => assignment.duration
      }
    end
  end

  def shifts_by_section
    shifts.includes(:sections).group_by { |shift| shift.sections.first }
  end

  private

  def mapped_assignments
    return @mapped_assignments if @mapped_assignments
    @mapped_assignments = {}
    assignments_by_section.each do |section, assignments|
      assignments.each do |assignment|
        key = [section.id, assignment.shift_id, assignment.date]
        @mapped_assignments[key] ||= []
        @mapped_assignments[key] << assignment
      end
    end
  end

  def shifts
    @shifts ||= Shift.on_call
  end

  def assignments_by_section
    @assignments_by_section ||= Section.all.each_with_object({}) do |section, hsh|
      published_schedules = section.weekly_schedules.published.include_dates(dates)
      published_dates = (published_schedules.map(&:dates).flatten || []).sort.uniq
      hsh[section] = section.assignments.where(:date => published_dates)
    end
  end

  def physicians_by_id
    @physician_ids ||= assignments_by_section.values.flatten.map(&:physician_id).uniq
    @physicians_by_id ||= Physician.
      where(:id => @physician_ids).
      includes(:names_alias).
      hash_by_id
  end
end
