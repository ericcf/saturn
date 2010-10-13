class SectionMembership < ActiveRecord::Base

  belongs_to :physician
  belongs_to :section

  validates :physician, :section, :presence => true
  validates_uniqueness_of :physician_id, :scope => :section_id
end
