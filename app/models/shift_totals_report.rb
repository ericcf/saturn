class ShiftTotalsReport
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_reader :start_date, :end_date, :shift_ids, :group_ids, :hide_empty_shifts
  attr_accessor :section

  validates :start_date, :end_date, :presence => true

  def initialize(attributes = {})
    return unless attributes.respond_to?(:each)
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  # allows this to play nicely with forms
  def persisted?
    false
  end

  def start_date=(value)
    @start_date = Date.parse(value)
  rescue ArgumentError
  end

  def end_date=(value)
    @end_date = Date.parse(value)
  rescue ArgumentError
  end

  def shift_ids=(values)
    if values.respond_to?(:map)
      @shift_ids = values.map { |v| v.to_i }
    end
  end

  def group_ids=(values)
    if values.respond_to?(:map)
      @group_ids = values.map { |v| v.to_i }
    end
  end

  def hide_empty_shifts=(value)
    @hide_empty_shifts = [1, "1", true, "true"].include?(value)
  end

  def shifts
    return @shifts if @shifts
    if hide_empty_shifts
      @shifts = Shift.where(:id => published_assignments.map(&:shift_id).uniq)
    else
      @shifts = Shift.where(:id => shift_ids).select("id, title")
    end
  end

  def groups
    @groups ||= RadDirectory::Group.where(:id => group_ids).select("id, title")
  end

  def physicians
    @physicians ||= section.members.select("id, given_name, other_given_names, family_name, suffixes").includes(:names_alias, :memberships)
  end

  def published_assignments
    #@published_assignments ||= section.assignments.
    #  published.
    #  date_in_range(start_date, end_date).
    #  includes(:shift).
    #  where(:physician_id => physicians_by_group.values.flatten.map(&:id))
    dates = (start_date..end_date).to_a
    published_schedules = section.weekly_schedules.published.include_dates(dates)
    published_dates = published_schedules.map(&:dates).flatten
    physician_ids = physicians_by_group.values.flatten.map(&:id)
    @published_assignments = section.assignments.
      where(:physician_id => physician_ids, :date => published_dates)
  end

  # returns a hash mapping physicians to groups, excluding empty groups, i.e.
  # { <RadDirectory::Group...> => [<Physician...>, ...] }
  def physicians_by_group
    @physicians_by_group ||= groups.each_with_object({}) do |group, grouped_members|
      grouped_members[group] = physicians.select do |physician|
        physician.in_group? group
      end
    end.delete_if { |k, v| v.empty? }
  end

  def totals_by_physician_id_and_shift_id
    @totals_by_physician_id_and_shift_id ||=
      published_assignments.each_with_object({}) do |assignment, hsh|
        key = [assignment.physician_id, assignment.shift_id]
        hsh[key] = (hsh[key] ||= 0.0) + assignment.fixed_duration
      end
  end

  def totals_by_group_id_and_shift_id
    return @totals_by_group_id_and_shift_id unless @totals_by_group_id_and_shift_id.nil?
    @totals_by_group_id_and_shift_id = {}
    totals_by_physician_id_and_shift_id.each do |key, total|
      physician_id, shift_id = key
      physicians_by_group.each do |group, physicians|
        if physicians.map(&:id).include?(physician_id)
          key = [group.id, shift_id]
          @totals_by_group_id_and_shift_id[key] ||= 0.0
          @totals_by_group_id_and_shift_id[key] += total
        end
      end
    end
    @totals_by_group_id_and_shift_id
  end

  def totals_by_physician_id_and_day(shift_id)
    published_assignments.each_with_object({}) do |assignment, hsh|
      if assignment.shift_id == shift_id
        key = [assignment.physician_id, assignment.date.wday]
        hsh[key] = (hsh[key] ||= 0.0) + assignment.fixed_duration
      end
    end
  end

  def totals_by_group_id_and_day(shift_id)
    totals = {}
    totals_by_physician_id_and_day(shift_id).each do |key, total|
      physician_id, day = key
      physicians_by_group.each do |group, physicians|
        if physicians.map(&:id).include?(physician_id)
          key = [group.id, day]
          totals[key] ||= 0.0
          totals[key] += total
        end
      end
    end
    totals
  end
end
