class ShiftWeekNote < ActiveRecord::Base

  attr_accessible :shift, :shift_id, :weekly_schedule, :weekly_schedule_id,
    :text

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
