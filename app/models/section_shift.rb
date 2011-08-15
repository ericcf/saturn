class SectionShift < ActiveRecord::Base

  attr_accessible :section, :section_id, :shift, :shift_id, :display_color,
    :position, :retired_on, :retire

  has_many :shift_tag_assignments, :dependent => :destroy
  has_many :shift_tags, :through => :shift_tag_assignments
  belongs_to :section
  belongs_to :shift
  belongs_to :call_shift, :foreign_key => :shift_id
  belongs_to :vacation_shift, :foreign_key => :shift_id
  belongs_to :meeting_shift, :foreign_key => :shift_id

  validates :section, :shift, :position, :presence => true
  validates_associated :section, :shift
  validates :display_color, :format => { :with => %r{^#[0-9a-f]{3,6}$}i },
    :allow_nil => true

  default_scope :order => "position"
  scope :active_as_of, lambda { |cutoff_date|
    where(["section_shifts.retired_on is null or section_shifts.retired_on > ?", cutoff_date])
  }
  scope :retired_as_of, lambda { |cutoff_date|
    where(["section_shifts.retired_on <= ?", cutoff_date])
  }

  after_initialize :populate_defaults

  def retire
  end

  def retire=(value)
    if value.to_i == 1 && retired_on.nil?
      self[:retired_on] = Date.today
    elsif value.to_i == 0
      self[:retired_on] = nil
    end
  end

  private

  def populate_defaults
    self.display_color = "#000000" unless display_color?
  end
end
