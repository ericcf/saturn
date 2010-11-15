class ShiftTag < ActiveRecord::Base

  before_destroy :ensure_not_referenced_by_any_assignment
  has_many :assignments,
    :class_name => "ShiftTagAssignment",
    :dependent => :destroy
  has_many :shifts, :through => :assignments
  has_one :daily_shift_count_rule, :dependent => :destroy
  belongs_to :section

  validates :section, :title, :presence => true
  validates_uniqueness_of :title, :scope => :section_id

  default_scope :order => :title, :include => :shifts
  scope :title_like, lambda { |term| where(["title like ?", "%#{term}%"]) }

  def clear_assignments
  end

  def clear_assignments=(value)
    if value.to_i == 1
      assignments.clear
    end
  end

  private

  def ensure_not_referenced_by_any_assignment
    return true if assignments.count.zero?
    errors[:base] << "Shifts present"
    false
  end
end
