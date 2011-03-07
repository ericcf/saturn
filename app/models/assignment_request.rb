class AssignmentRequest < ActiveRecord::Base

  attr_accessible :requester, :requester_id, :shift, :shift_id,
    :start_date, :end_date, :comments

  STATUS = {
    :pending => "pending",
    :approved => "approved"
  }

  belongs_to :requester, :class_name => "Physician"
  belongs_to :shift

  validates :requester, :shift, :status, :start_date, :presence => true
  validates_associated :requester, :shift
  validate :end_date_on_or_after_start_date?
  validate :start_date_on_or_after_today?
  validate :requester_associated_with_shift?
  validates_inclusion_of :status, :in => STATUS.values

  def sections
    shift.sections
  end

  def approve!
    dates = (start_date..(end_date || start_date)).to_a
    Assignment.create_for_dates(dates,
      :shift_id => shift_id,
      :physician_id => requester_id
    )
    update_attribute(:status, STATUS[:approved])
  end

  private

  def end_date_on_or_after_start_date?
    unless self[:end_date].blank? or self[:start_date].blank?
      unless self[:end_date] >= self[:start_date]
        errors.add(:end_date, "must occur after the start date")
      end
    end
  end

  def start_date_on_or_after_today?
    unless self[:start_date].blank?
      unless self[:start_date] >= Date.today
        errors.add(:start_date, "must occur on or after today")
      end
    end
  end

  def requester_associated_with_shift?
    unless requester.blank?
      associated_shift_ids = requester.shifts.map(&:id).uniq
      unless associated_shift_ids.include? shift_id
        errors.add(:requester_id, "cannot be assigned to this shift")
      end
    end
  end
end
