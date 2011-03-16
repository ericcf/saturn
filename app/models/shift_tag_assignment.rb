class ShiftTagAssignment < ActiveRecord::Base

  attr_accessible :shift_tag, :shift_tag_id, :section_shift, :section_shift_id

  belongs_to :shift_tag
  belongs_to :section_shift

  validates :shift_tag, :section_shift, :presence => true
  validates_uniqueness_of :section_shift_id, :scope => :shift_tag_id
end
