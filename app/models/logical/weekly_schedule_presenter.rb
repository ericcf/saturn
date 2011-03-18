require 'tables'

module Logical

  class WeeklySchedulePresenter < ::Logical::ValidatableModel

    attr_accessor :section, :dates, :assignments, :weekly_schedule,
      :physician_names_by_id
    attr_writer :options

    def shifts
      @shifts ||= weekly_schedule.shifts
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

    # calculate the week note for the specified shift
    def week_note(shift_id)
      @note_by_shift_id ||= weekly_schedule.shift_week_notes.group_by(&:shift_id)
      (@note_by_shift_id[shift_id] || [ShiftWeekNote.new]).first.text
    end

    # calculate the display color for the specified shift
    def display_color(shift_id)
      @section_shift_by_shift_id ||= section.section_shifts.group_by(&:shift_id)
      @section_shift_by_shift_id[shift_id].first.display_color
    end

    def title(shift_id)
      @shift_titles_by_shift_id ||= section.shifts.each_with_object({}) do |s, hsh|
        hsh[s.id] = s.title
      end
      @shift_titles_by_shift_id[shift_id]
    end

    # process the headers and return hashes to pass to the view
    def headers(type)
      case type
      when :dates
        dates.map { |d| { :object => d, :type => "date" } }
      when :shifts
        shifts.map do |s|
          {
            :object => {
              :title => title(s.id),
              :color => display_color(s.id),
              :phone => s.phone,
              :note => week_note(s.id)
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

    def assignment_key(assignment)
      {
        :shifts => [shift_index(assignment), date_index(assignment.date)],
        :physicians => [physician_index(assignment), date_index(assignment.date)]
      }[@options[:row_type]]
    end

    def request_key(request)
      {
        :shifts => [shift_index(request), date_index(request.start_date)],
        :physicians => [physician_index(request), date_index(request.start_date)]
      }[@options[:row_type]]
    end

    def assignment_summary(assignment, status = nil)
      {
        :shifts => {
          :text => physician_names_by_id[assignment.physician_id],
          :note => assignment.public_note,
          :duration => assignment.duration,
          :status => status
        },
        :physicians => {
          :text => title(assignment.shift_id),
          :note => assignment.public_note,
          :duration => assignment.duration,
          :status => status
        }
      }[@options[:row_type]]
    end

    # process the assignments and map them by specified row, col key
    def indexed_values
      values = {}
      assignments.each do |assignment|
        index = assignment_key(assignment)
        values[index] ||= []
        values[index] << assignment_summary(assignment)
      end
      weekly_schedule.assignment_requests.pending.each do |request|
        request.dates.each do |request_date|
          virtual_request = AssignmentRequest.new(:start_date => request_date,
            :requester_id => request.requester_id,
            :shift_id => request.shift_id
          )
          virtual_request[:status] = request.status
          index = request_key(virtual_request)
          values[index] ||= []
          values[index] << assignment_summary(virtual_request, request.status)
        end
      end
      values
    end

    # calculate the index of the date within the schedule dates
    def date_index(date)
      dates.find_index(date)
    end

    # calculate the index of the assignment within the section shifts
    def shift_index(assignment)
      @shift_ids ||= shifts.map(&:id)
      @shift_ids.find_index(assignment.shift_id)
    end

    # calculate the index of the assignment within the member physicians
    def physician_index(assignment)
      @physician_ids ||= section.members_by_group.values.flatten.map(&:id)
      @physician_ids.find_index(assignment.physician_id)
    end
  end
end
