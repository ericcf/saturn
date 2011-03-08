require 'tables'

class WeeklySchedulePresenter

  attr_accessor :section, :dates, :assignments, :weekly_schedule, :physician_names_by_id
  attr_writer :options

  def initialize(attributes = {})
    return unless attributes.respond_to?(:each)
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def shifts
    @shifts ||= section.active_shifts(:as_of => dates.first).
      includes(:shift_tags)
  end

  private

  def tabular_data
    @tabular_data ||= Tables::TabularStore.new(
      :row_headers => headers(@options[:row_type]),
      :col_headers => headers(@options[:col_type]),
      :values => indexed_values
    )
  end

  def method_missing(sym, *args, &block)
    tabular_data.send sym, *args, &block
  end

  def week_note_by_shift_id(shift_id)
    @note_by_shift_id ||= weekly_schedule.shift_week_notes.group_by(&:shift_id)
    (@note_by_shift_id[shift_id] || [ShiftWeekNote.new]).first
  end

  def display_color(shift_id)
    @section_shift_by_shift_id ||= section.section_shifts.group_by(&:shift_id)
    @section_shift_by_shift_id[shift_id].first.display_color
  end

  def headers(type)
    case type
    when :dates
      dates.map { |d| { :object => d, :type => "date" } }
    when :shifts
      shifts.map do |s|
        note = week_note_by_shift_id(s.id)
        {
          :object => {
            :title => s.title,
            :color => display_color(s.id),
            :phone => s.phone,
            :note => note.text
          },
          :type => "shift"
        }
      end
    when :physicians
      section.members_by_group.values.flatten.map do |physician|
        {
          :object => {
            :title => physician.short_name,
            :id => physician.id
          },
          :type => "physician"
        }
      end
    end
  end

  def indexed_values
    values = {}
    case @options[:col_type]
    when :dates
      case @options[:row_type]
      when :shifts
        assignments.each do |assignment|
          index = [shift_index(assignment), date_index(assignment)]
          values[index] ||= []
          values[index] << {
            :text => physician_names_by_id[assignment.physician_id],
            :note => assignment.public_note,
            :duration => assignment.duration
          }
        end
      when :physicians
        assignments.each do |assignment|
          index = [physician_index(assignment), date_index(assignment)]
          values[index] ||= []
          values[index] << {
            :text => assignment.shift_title,
            :note => assignment.public_note,
            :duration => assignment.duration
          }
        end
      end
    end
    values
  end

  def date_index(assignment)
    dates.find_index(assignment.date)
  end

  def shift_index(assignment)
    @shift_ids ||= shifts.map(&:id)
    @shift_ids.find_index(assignment.shift_id)
  end

  def physician_index(assignment)
    @physician_ids ||= section.members_by_group.values.flatten.map(&:id)
    @physician_ids.find_index(assignment.physician_id)
  end
end
