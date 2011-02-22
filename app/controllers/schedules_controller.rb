require 'date_helpers'

class SchedulesController < ApplicationController

  include DateHelpers

  def weekly_call
    start_date = params[:date].nil? ? Date.today.at_beginning_of_week : Date.civil(params[:date][:year].to_i, params[:date][:month].to_i, params[:date][:day].to_i)
    @dates = week_dates_beginning_with(start_date)
    schedules = WeeklySchedule.
      find_all_by_is_published_and_date(true, @dates + [start_date.at_beginning_of_week])
    @call_shifts = Shift.includes(:shift_tags).
      where("shift_tags.title like ?", "%Call%")
    @call_assignments = Assignment.by_schedules_and_shifts(
      schedules,
      @call_shifts
    )
    @physicians_by_id = Physician.
      where(:id => @call_assignments.map(&:physician_id)).
      includes(:names_alias).
      hash_by_id
    @notes = @call_assignments.map(&:public_note_details).compact
  end

  def show_weekly_section
    request_date = params[:date].nil? ? nil : "#{params[:date][:year]}-#{params[:date][:month]}-#{params[:date][:day]}"
    start_date = monday_of_week_with(request_date)
    @dates = week_dates_beginning_with(start_date)
    @section = Section.find(params[:section_id])
    schedule = @section.weekly_schedules.
      find_by_is_published_and_date(true, start_date) ||
      @section.weekly_schedules.build(:date => start_date)
    @assignments = schedule.assignments.includes(:shift)
    @physician_names_by_id = @section.members.includes(:names_alias).each_with_object({}) do |physician, hsh|
      hsh[physician.id] = physician.short_name
    end
    @view_mode = params[:view_mode]
    @schedule_presenter = case @view_mode.to_i
      when 0, 1
        WeeklySchedulePresenter.new(:section => @section, :dates => @dates,
          :assignments => @assignments, :weekly_schedule => schedule,
          :physician_names_by_id => @physician_names_by_id,
          :options => { :col_type => :dates, :row_type => :shifts }
        )
      when 2
        WeeklySchedulePresenter.new(:section => @section, :dates => @dates,
          :assignments => @assignments, :weekly_schedule => schedule,
          :physician_names_by_id => @physician_names_by_id,
          :options => { :col_type => :dates, :row_type => :physicians }
        )
      end

    respond_to do |format|
      format.html
      format.xls { render :xls => @schedule_presenter, :template => "schedules/weekly_section_schedule.xls", :layout => false }
    end
  end
end
