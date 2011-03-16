class Shift < ActiveRecord::Base

  attr_accessible :title, :description, :duration, :phone, :section_ids,
    :shift_tags

  has_friendly_id :title, :use_slug => true

  with_options :dependent => :destroy do |assoc|
    assoc.has_many :shift_week_notes
    assoc.has_many :section_shifts
  end
  has_many :shift_tag_assignments, :through => :section_shifts
  has_many :sections, :through => :section_shifts
  accepts_nested_attributes_for :section_shifts, :allow_destroy => true

  validates :title, :duration, :presence => true

  before_validation { clean_text_attributes :title, :description, :phone }

  def type_name
    ""
  end

  def display_color_for_section(section)
    section_shifts.where(:section_id => section.id).select(:display_color).
      map(&:display_color).first
  end

  def shift_tags
    ShiftTag.where(:id => shift_tag_assignments.map(&:shift_tag_id))
  end

  def shift_tags=(ids)
    existing_ids = shift_tag_assignments.map(&:shift_tag_id)
    saved_ids = ShiftTag.where(:id => ids).map do |shift_tag|
      section_shift = section_shifts.where(:section_id => shift_tag.section_id).
        first
      unless existing_ids.include?(shift_tag.id)
        ShiftTagAssignment.create(:section_shift_id => section_shift.id,
          :shift_tag_id => shift_tag.id
        )
      end
      shift_tag.id
    end
    existing_ids.each do |shift_tag_id|
      unless saved_ids.include?(shift_tag_id)
        shift_tag = ShiftTag.find(shift_tag_id)
        section_shift = section_shifts.
          where(:section_id => shift_tag.section_id).
          first
        ShiftTagAssignment.find_by_section_shift_id_and_shift_tag_id(
          section_shift.id,
          shift_tag.id
        ).destroy
      end
    end
  end
end
