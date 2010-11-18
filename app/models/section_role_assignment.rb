class SectionRoleAssignment < ActiveRecord::Base

  attr_accessible :section, :section_id, :role, :role_id

  belongs_to :section
  belongs_to :role, :class_name => 'Deadbolt::Role'

  validates :section, :role, :presence => true
  validates_associated :section, :role
end
