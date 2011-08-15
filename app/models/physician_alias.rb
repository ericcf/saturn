class PhysicianAlias < ActiveRecord::Base

  attr_accessible :physician, :physician_id, :initials, :short_name

  belongs_to :physician

  validates_presence_of :physician_id
  validates_format_of :initials, :with => /^[a-z]{1,3}$/i, :allow_nil => true,
    :message => "must be either 2 or 3 letters"

  before_validation { clean_text_attributes :initials, :short_name }
end
