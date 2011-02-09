class ShiftWeekNote < ActiveRecord::Base

  belongs_to :shift
  belongs_to :weekly_schedule

  validates :shift, :weekly_schedule, :text, :presence => true
  validates_associated :shift

  def to_json(options = {})
    [
      "\"shift_week_note\":{",
        id ? "\"id\":#{id}," : nil,
        "\"text\":\"#{text}\",",
        "\"shift_id\":#{shift_id}",
      "}"
    ].compact.join("")
  end
end
