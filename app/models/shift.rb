class Shift < ActiveRecord::Base

  has_many :shift_tag_assignments, :dependent => :destroy
  has_many :shift_tags, :through => :shift_tag_assignments
  belongs_to :section

  validates_presence_of :title, :duration, :position, :section
  validates_uniqueness_of :title, :scope => :section_id

  before_validation { clean_attributes :title, :description, :phone }

  default_scope :order => "position"
  scope :active_as_of, lambda { |cutoff_date|
    where(["retired_on is null or retired_on > ?", cutoff_date])
  }
  scope :retired_as_of, lambda { |cutoff_date|
    where(["retired_on <= ?", cutoff_date])
  }

  def Shift.by_tag(term)
    ShiftTag.where(:title => term).joins(:shifts).map(&:shifts).flatten.uniq
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

  def retire
  end

  def retire=(value)
    if value.to_i == 1
      self[:retired_on] = Date.today
    end
  end
end
