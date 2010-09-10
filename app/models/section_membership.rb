class SectionMembership < ActiveRecord::Base

  belongs_to :person
  belongs_to :section

  validates :person, :section, :presence => true
  validates_uniqueness_of :person_id, :scope => :section_id
end
