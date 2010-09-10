class PersonAlias < ActiveRecord::Base

  belongs_to :person

  validates_presence_of :person
  validates_format_of :initials, :with => /^[a-z]{1,3}$/i,
    :message => "must be either 2 or 3 letters"

  before_validation :filter_attributes

  private

  def filter_attributes
    [:initials, :short_name].each do |attr|
      unless self[attr].nil?
        self[attr].strip!
        self[attr] = nil if self[attr].blank?
      end
    end
  end
end
