class AssignmentRequest < ActiveRecord::Base

  attr_accessible :requester, :requester_id, :shift, :shift_id, :start_date, :end_date,
    :comments

  STATUS = {
    :pending => "pending",
    :approved => "approved"
  }

  belongs_to :shift

  validates :requester_id, :shift, :status, :start_date, :presence => true
  validates_associated :shift
  validate :end_date_on_or_after_start_date?
  validate :start_date_on_or_after_today?
  validate :requester_associated_with_shift?
  validates_inclusion_of :status, :in => STATUS.values

  scope :include_dates, lambda { |dates|
    sorted_dates = dates.sort
    where("start_date <= ? or end_date >= ?", sorted_dates.last, sorted_dates.first)
  }
  scope :pending, where(:status => STATUS[:pending])

  delegate :sections, :title, :to => :shift, :prefix => true

  def physician_id
    requester_id
  end

  def requester
    requester_id && Physician.find(requester_id)

  rescue ActiveResource::ResourceNotFound
    nil
  end

  def public_note
    status
  end

  def duration
  end

  def dates
    (start_date..(end_date || start_date)).to_a
  end

  def approve!
    Assignment.create_for_dates(dates,
      :shift_id => shift_id,
      :physician_id => requester_id
    )
    update_attribute(:status, STATUS[:approved])
  end

  def to_json
    [
    "{",
      "\"date\":\"#{start_date}\",",
      "\"duration\":null,",
      "\"id\":null,",
      "\"position\":1,",
      "\"private_note\":null,",
      "\"public_note\":\"request #{status}\",",
      "\"immutable\":true,",
      "\"shift_id\":#{shift_id},",
      "\"physician_id\":#{requester_id}",
    "}"
    ].join("")
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
    unless requester_id.blank?
      associated_shift_ids = requester.shifts.map(&:id).uniq
      unless associated_shift_ids.include? shift_id
        errors.add(:requester_id, "cannot be assigned to this shift")
      end
    end
  end
end
