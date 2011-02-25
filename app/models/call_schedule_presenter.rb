require 'tables'

class CallSchedulePresenter

  attr_accessor :dates

  def initialize(attributes = {})
    return unless attributes.respond_to?(:each)
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def shifts
    @shifts ||= Shift.includes(:shift_tags).where("shift_tags.title like ?", "%Call%")
  end

  def schedules
    @schedules ||= WeeklySchedule.find_all_by_is_published_and_date(true, dates)
  end

  def assignments
    @assignments ||= Assignment.by_schedules_and_shifts(schedules, shifts)
  end

  def summaries_by_section_id_shift_id_and_date(section_id, shift_id, date)
    @mapped_assignments ||= assignments.group_by { |a| [a.weekly_schedule.section.id, a.shift_id, a.date] }
    assignments = @mapped_assignments[[section_id, shift_id, date]] || []
    assignments.map do |assignment|
      {
        :text => physicians_by_id[assignment.physician_id].short_name,
        :note => assignment.public_note,
        :duration => assignment.duration
      }
    end
  end

  def shifts_by_section
    call_shifts = Shift.on_call
    sections = Section.joins(:section_shifts) & SectionShift.where(:shift_id => call_shifts)
    sections.each_with_object({}) do |section, hsh|
      hsh[section] = section.shifts.on_call
    end
  end

  def physicians_by_id
    @physicians_by_id ||= Physician.
      where(:id => assignments.map(&:physician_id)).
      includes(:names_alias).
      hash_by_id
  end

  def notes
    @notes ||= assignments.map(&:public_note_details).compact
  end
end
