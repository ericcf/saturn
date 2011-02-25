class WeeklySchedule < ActiveRecord::Base

  has_many :assignments, :dependent => :destroy
  accepts_nested_attributes_for :assignments, :allow_destroy => true
  has_many :shift_week_notes, :dependent => :destroy
  accepts_nested_attributes_for :shift_week_notes, :allow_destroy => true
  belongs_to :section

  validates_presence_of :section, :date
  validates_uniqueness_of :date, :scope => :section_id

  scope :include_date, lambda { |date|
    where("weekly_schedules.date <= ? and weekly_schedules.date >= ?", date, date - 6)
  }

  def read_only_assignments
    @read_only_assignments ||= assignments.select("date, duration, id, position, private_note, public_note, shift_id, physician_id, updated_at").includes(:shift)
  end

  def dates
    @dates ||= (date..date+6.days).entries
  end

  def holiday_titles_by_date
    @holidat_titles_by_date ||= Holiday.where(:date => dates).each_with_object({}) do |holiday, hsh|
      hsh[holiday.date] = holiday.title
    end
  end

  def rules_conflicts
    @rules_conflicts ||= RulesConflictSummary.new(
      :section => section,
      :weekly_schedule => self,
      :assignments => read_only_assignments,
      :ordered_physician_ids => section.members.order(:family_name).map(&:id)
    )
  end

  def to_json(options = {})
    options[:only_delta_attributes] ||= false
    static_attributes_json = nil
    static_attributes_json = options[:only_delta_attributes] ? nil : [
      date_json,
      section.members_by_group_json,
      dates_json
    ].join(",")
    [
      "{",
        "\"weekly_schedule\":",
          "{",
            [
            static_attributes_json,
            last_update_json,
            rules_conflicts.to_json,
            id ? "\"id\":#{id}" : nil,
            "\"is_published\":#{is_published}",
            "\"shift_weeks\":[#{shift_weeks_json}]",
            "\"error_messages\":\"#{errors.values.flatten.join(", ")}\"",
            ].compact.join(","),
          "}",
      "}"
    ].join("")
  end

  def date_json
    [
    "\"date\":",
      "{",
        "\"year\":#{date.year},",
        "\"month\":#{date.month},",
        "\"day\":#{date.day}",
      "}"
    ].join("")
  end

  def dates_json
    "\"dates\":[#{dates.map do |date|
      [
      "{",
        "\"holiday_title\": #{holiday_titles_by_date[date] ? "\"#{holiday_titles_by_date[date]}\"" : "null"},",
        "\"year\": #{date.year},",
        "\"month\": #{date.month},",
        "\"day\": #{date.day}",
      "}"
      ].join("")
    end.join(",")}]"
  end
  
  def shift_weeks_json
    assignments_by_shift_id_and_date = read_only_assignments.each_with_object({}) do |assignment, hsh|
      hsh[[assignment.shift_id, assignment.date]] ||= []
      hsh[[assignment.shift_id, assignment.date]] << assignment
    end
    notes_by_shift_id = shift_week_notes.each_with_object({}) do |note, hsh|
      hsh[note.shift_id] = note
    end
    section.active_shifts_as_of(date).select("id, title").map do |shift|
      shift_week_note = notes_by_shift_id[shift.id] || ShiftWeekNote.new(:shift_id => shift.id)
      [
      "{",
        "\"shift_id\":#{shift.id},",
        "\"shift_title\":\"#{shift.title}\",",
        shift_week_note.to_json + ",",
        "\"shift_days\":[#{dates.map do |day|
          [
          "{",
            "\"date\":\"#{day}\",",
            "\"shift_id\":#{shift.id},",
            "\"assignments\":[#{(assignments_by_shift_id_and_date[[shift.id, day]] || []).map do |assignment|
              assignment.to_json
            end.join(",")}]",
          "}"
          ].join("")
        end.join(",")}]",
      "}"
      ].join("")
    end.join(",")
  end

  def last_update_json
    return nil unless last_update
    [
      "\"last_update\":",
        "{",
          "\"year\":#{last_update.year},",
          "\"month\":#{last_update.month},",
          "\"day\":#{last_update.day},",
          "\"hour\":#{last_update.hour},",
          "\"minute\":#{last_update.min}",
        "}"
    ].join("")
  end

  def last_update
    return @last_update if @last_update
    return nil unless updated_at
    last_assignment = assignments.order("updated_at DESC").limit(1).first
    @last_update = [
      updated_at,
      last_assignment ? last_assignment.updated_at : updated_at
    ].max
  end
end
