require 'tables'

class WeeklySchedulePresenter

  def initialize(section, dates, assignments, options={})
    @section, @dates, @assignments = section, dates, assignments
    start_date = @dates.first
    @shifts = @section.shifts.active_as_of(start_date).includes(:shift_tags)
    @row_type, @col_type = options[:row_type], options[:col_type]
    @tabular_data = Tables::TabularStore.new(
      :row_headers => headers(@row_type),
      :col_headers => headers(@col_type),
      :values => indexed_values
    )
  end

  private

  def method_missing(sym, *args, &block)
    @tabular_data.send sym, *args, &block
  end

  def headers(type)
    case type
    when :dates
      @dates.map { |d| { :object => d, :type => "date" } }
    when :shifts
      @shifts.map { |s| { :object => s, :type => "shift" } }
    when :physicians
      @section.members.map { |p| { :object => p, :type => "physician" } }
    end
  end

  def indexed_values
    values = {}
    case @col_type
    when :dates
      case @row_type
      when :shifts
        physicians = Physician.with_assignments(@assignments).
          includes(:names_alias).hash_by_id
        @assignments.each do |assignment|
          index = [shift_index(assignment), date_index(assignment)]
          values[index] ||= []
          values[index] << physicians[assignment.physician_id].short_name
        end
      when :physicians
        @assignments.each do |assignment|
          index = [physician_index(assignment), date_index(assignment)]
          values[index] ||= []
          values[index] << assignment.shift.title
        end
      end
    end
    values
  end

  def date_index(assignment)
    @dates.find_index(assignment.date)
  end

  def shift_index(assignment)
    @shift_ids ||= @shifts.map(&:id)
    @shift_ids.find_index(assignment.shift_id)
  end

  def physician_index(assignment)
    @physician_ids ||= @section.members.map(&:id)
    @physician_ids.find_index(assignment.physician_id)
  end
end
