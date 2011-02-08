class ShiftWeekNote < ActiveRecord::Base

  belongs_to :shift
  belongs_to :weekly_schedule

  validates :shift, :weekly_schedule, :text, :presence => true
  validates_associated :shift
end
