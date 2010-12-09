class VacationRequest < ActiveRecord::Base

  attr_accessible :requester, :requester_id, :section, :section_id, :shift,
    :shift_id, :status, :start_date, :end_date

  STATUS_PENDING = "pending"
  STATUS_REJECTED = "rejected"
  STATUS_APPROVED = "approved"
  STATUS_CONFLICTING = "conflicting"
  STATUSES = [STATUS_PENDING, STATUS_REJECTED, STATUS_APPROVED, STATUS_CONFLICTING]

  belongs_to :requester, :class_name => "Physician"
  belongs_to :section
  belongs_to :shift

  validates :requester, :section, :shift, :status, :start_date, :presence => true
  validates_associated :requester, :section, :shift
  validate :end_date_on_or_after_start_date
  validates_inclusion_of :status, :in => STATUSES

  def approve
    (start_date..(end_date || start_date)).each do |date|
      schedule = section.find_or_create_weekly_schedule_by_included_date(date)
      schedule.assignments.create(:date => date, :shift => shift, :physician_id => requester_id)
    end
    update_attribute(:status, STATUS_APPROVED)
  end

  private

  def end_date_on_or_after_start_date
    unless self[:end_date].blank? or self[:start_date].blank?
      unless self[:end_date] >= self[:start_date]
        errors.add(:end_date, "must occur after the start date")
      end
    end
  end

end
