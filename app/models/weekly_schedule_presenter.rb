require 'tables'

class WeeklySchedulePresenter

  attr_accessor :section, :dates, :assignments, :weekly_schedule, :physician_names_by_id
  attr_writer :options
  attr_reader :shifts

  def initialize(attributes = {})
    return unless attributes.respond_to?(:each)
    attributes.each do |name, value|
      send("#{name}=", value)
    end
    @shifts = section.shifts.active_as_of(dates.first).includes(:shift_tags)
    @tabular_data = Tables::TabularStore.new(
      :row_headers => headers(@options[:row_type]),
      :col_headers => headers(@options[:col_type]),
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
      dates.map { |d| { :object => d, :type => "date" } }
    when :shifts
      shifts.map do |s|
        note = (ShiftWeekNote.find_by_shift_id_and_weekly_schedule_id(s.id, weekly_schedule.id) || ShiftWeekNote.new)
        {
          :object => {
            :title => s.title,
            :color => s.display_color,
            :phone => s.phone,
            :note => note.text
          },
          :type => "shift"
        }
      end
    when :physicians
      section.members_by_group.values.flatten.map { |p| { :object => p, :type => "physician" } }
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
          data = physician_names_by_id[assignment.physician_id]
          data += " <span class='note'><img src='/images/pub-note.gif' alt='#{assignment.public_note}' /><span class='note-text'>#{assignment.public_note}</span></span>" if assignment.public_note.present?
          values[index] << data
        end
      when :physicians
        assignments.each do |assignment|
          index = [physician_index(assignment), date_index(assignment)]
          values[index] ||= []
          data = assignment.shift.title
          data += " <img src='/images/pub-note.gif' title='#{assignment.public_note}' />" if assignment.public_note.present?
          values[index] << data
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
