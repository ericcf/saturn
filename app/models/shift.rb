class Shift < ActiveRecord::Base

  with_options :dependent => :destroy do |assoc|
    assoc.has_many :shift_tag_assignments
    assoc.has_many :shift_week_notes
    assoc.has_many :section_shifts
  end
  has_many :shift_tags, :through => :shift_tag_assignments
  has_many :sections, :through => :section_shifts
  accepts_nested_attributes_for :section_shifts, :allow_destroy => true

  validates :title, :duration, :presence => true

  before_validation { clean_text_attributes :title, :description, :phone }

  def self.on_call
    tags = ShiftTag.where("shift_tags.title like ?", "%Call%")
    where(:id => tags.map(&:shifts).flatten.map(&:id).uniq)
  end

  def display_color_for_section(section)
    section_shift = section_shifts.where(:section_id => section.id)
    if section_shift.present?
      section_shift.first.display_color
    end
  end

  def tags
    shift_tags.map(&:title).join(", ")
  end

  def tags=(tags_string)
    tags_string.split(",").each do |tag_title|
      title = tag_title.strip
      unless title.blank? || shift_tags.map(&:title).include?(title)
        shift_tags << section.shift_tags.find_or_create_by_title(title)
      end
    end
  end
end
