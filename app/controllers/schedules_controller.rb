require 'saturn/dates'

class SchedulesController < ApplicationController

  include Saturn::Dates

  def weekly_call
    start_date = (params[:date].nil? ? Date.today : Date.civil(params[:date][:year].to_i, params[:date][:month].to_i, params[:date][:day].to_i)).at_beginning_of_week
    dates = week_dates_beginning_with(start_date)
    @schedule_presenter = ::Logical::CallSchedulePresenter.new(:dates => dates)
  end

  def show_weekly_section
    request_date = params[:date].nil? ? nil : "#{params[:date][:year]}-#{params[:date][:month]}-#{params[:date][:day]}"
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
end
