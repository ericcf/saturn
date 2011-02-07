class WeeklySchedule < ActiveRecord::Base

  has_many :assignments, :dependent => :destroy
  accepts_nested_attributes_for :assignments, :allow_destroy => true
  belongs_to :section

  validates_presence_of :section, :date
  validates_uniqueness_of :date, :scope => :section_id

  scope :include_date, lambda { |date|
    where("weekly_schedules.date <= ? and weekly_schedules.date >= ?", date, date - 6)
  }

  def read_only_assignments
    assignments.select("date, duration, id, position, private_note, public_note, shift_id, physician_id, updated_at")
  end

  def dates
    @dates ||= (date..date+6.days).entries
  end

  def holiday_titles_by_date
    @holidat_titles_by_date ||= Holiday.where(:date => dates).each_with_object({}) do |holiday, hsh|
      hsh[holiday.date] = holiday.title
    end
  end

  def to_json(options = {})
    options[:only_delta_attributes] ||= false
    assignments = read_only_assignments.includes(:shift)
    rules_conflicts = RulesConflictSummary.new(:section => section,
      :weekly_schedule => self,
      :assignments => assignments
    )
    static_attributes_json = options[:only_delta_attributes] ? nil : [
      date_json,
      section.members_json,
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
            "\"shift_weeks\":[#{shift_weeks_json(assignments)}]",
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
  
  def shift_weeks_json(assignments)
    assignments_by_shift_id_and_date = assignments.each_with_object({}) do |assignment, hsh|
      hsh[[assignment.shift_id, assignment.date]] ||= []
      hsh[[assignment.shift_id, assignment.date]] << assignment
    end
    section.shifts.select("id, title").active_as_of(date).map do |shift|
      [
      "{",
        "\"shift_title\":\"#{shift.title}\",",
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
