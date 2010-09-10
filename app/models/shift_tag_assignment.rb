class ShiftTagAssignment < ActiveRecord::Base

  belongs_to :shift_tag
  belongs_to :shift

  validates :shift_tag, :shift, :presence => true
  validates_uniqueness_of :shift_id, :scope => :shift_tag_id
end
