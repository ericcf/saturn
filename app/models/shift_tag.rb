class ShiftTag < ActiveRecord::Base

  before_destroy :ensure_not_referenced_by_any_assignment
  has_many :assignments,
    :class_name => "ShiftTagAssignment",
    :dependent => :destroy
  has_many :shifts, :through => :assignments
  belongs_to :section

  validates :section, :title, :presence => true
  validates_uniqueness_of :title, :scope => :section_id
  validates_format_of :display_color, :with => /^[0-9a-fA-F]{6}$/,
    :allow_nil => true

  before_validation :filter_attributes

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

  def filter_attributes
    unless self[:display_color].nil?
      self[:display_color].strip!
      if self[:display_color].blank?
        self[:display_color] = nil
      end
    end
  end
end
