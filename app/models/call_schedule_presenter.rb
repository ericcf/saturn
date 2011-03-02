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
    Shift.on_call.includes(:sections).group_by { |shift| shift.sections.first }
  end

  private

  def mapped_assignments
    return @mapped_assignments if @mapped_assignments
    @mapped_assignments = {}
    Section.all.each do |section|
      published_schedule = section.weekly_schedules.published.
       where(:date => dates.first)
      if published_schedule
        published_schedule.first.assignments.each do |assignment|
          key = [section.id, assignment.shift_id, assignment.date]
          @mapped_assignments[key] ||= []
          @mapped_assignments[key] << assignment
        end
      end
    end
    @mapped_assignments
  end

  def physicians_by_id
    @physicians_by_id ||= Physician.
      includes(:names_alias).
      hash_by_id
  end
end
