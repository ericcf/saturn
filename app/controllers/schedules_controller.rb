require 'saturn/dates'

class SchedulesController < ApplicationController

  include Saturn::Dates

  def weekly_call
    dates = week_dates_beginning_with(week_start_date)
    @schedule_presenter = ::Logical::CallSchedulePresenter.new(:dates => dates)
  end

  def show_weekly_section
    date_params = params[:date] || params
    request_date = date_params[:year].nil? ? nil : "#{date_params[:year]}-#{date_params[:month]}-#{date_params[:day]}"
    start_date = monday_of_week_with(request_date)
    dates = week_dates_beginning_with(start_date)
    @section = Section.find(params[:section_id])
    schedule = @section.weekly_schedules.published.find_by_date(start_date) ||
      @section.weekly_schedules.build(:date => start_date)
    @assignments = schedule.is_published ? schedule.assignments : []
    physician_names_by_id = @section.members.includes(:names_alias).each_with_object({}) do |physician, hsh|
      hsh[physician.id] = physician.short_name
    end
    @view_mode = params[:view_mode]
    presenter_options = case @view_mode.to_i
      when 0, 1
        { :col_type => :dates, :row_type => :shifts }
      when 2
        { :col_type => :dates, :row_type => :physicians }
      end
    @schedule_presenter = ::Logical::WeeklySchedulePresenter.new(
      :section => @section,
      :dates => dates,
      :assignments => @assignments,
      :weekly_schedule => schedule,
      :physician_names_by_id => physician_names_by_id,
      :options => presenter_options
    )

    respond_to do |format|
      format.html { render :layout => "section" }
      format.xls { render :xls => @schedule_presenter, :template => "schedules/weekly_section_schedule.xls", :layout => false }
    end
  end

  private

  # calculate the date at the beginning of the week based on the params
  def week_start_date
    date_params = params[:date] || params
    request_date = date_params[:year].nil? ? nil : "#{date_params[:year]}-#{date_params[:month]}-#{date_params[:day]}"
    start_date = monday_of_week_with(request_date)
  end
end
