require 'date_helpers'

class SchedulesController < ApplicationController

  include DateHelpers

  before_filter :authenticate_user!, :only => [:edit_weekly_section,
    :create_weekly_section, :update_weekly_section]

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

  def edit_weekly_section
    date = params[:date] || [params[:year], params[:month], params[:day]].join("-")
    week_start_date = monday_of_week_with(date)
    @week_dates = week_dates_beginning_with(week_start_date)
    @section = Section.find(params[:section_id])
    @shifts = @section.shifts.active_as_of(week_start_date)
    @weekly_schedule = WeeklySchedule.find_by_section_id_and_date(
      params[:section_id],
      week_start_date
    ) || WeeklySchedule.new(
      :section_id => params[:section_id],
      :date => week_start_date
    )
    authorize! :update, @section
    @assignments = @weekly_schedule.assignments
    @grouped_people = @section.members_by_group
    @physicians_by_id = @section.members.hash_by_id
    @people_names = @section.members.includes(:names_alias).each_with_object({}) do |physician, hsh|
      hsh[physician.id] = physician.short_name
    end
  end

  def create_weekly_section
    schedule_attributes = params[:weekly_schedule].merge({
      :section_id => params[:section_id],
      :assignments_attributes => params[:assignments] || {}
    })
    @weekly_schedule = WeeklySchedule.new(schedule_attributes)
    @section = Section.find(params[:section_id])
    authorize! :update, @section
    if @weekly_schedule.save
      date = @weekly_schedule.date
      flash[:notice] = "Successfully created schedule"
      redirect_to edit_weekly_section_schedule_path(
        :section_id => params[:section_id],
        :year => date.year,
        :month => date.month,
        :day => date.day
      )
    else
      @week_start_date = Date.parse(params[:weekly_schedule][:date])
      @week_dates = week_dates_beginning_with(@week_start_date)
      @grouped_people = @section.members_by_group
      @assignments = @weekly_schedule.assignments_including([:physician, :shift])
      flash.now[:error] = "There was an error creating the schedule: #{@weekly_schedule.errors.full_messages.join(", ")}"
      render :edit_weekly_section
    end
  end

  def update_weekly_section
    schedule_attributes = {
      :assignments_attributes => params[:assignments] || {},
      :is_published => params[:weekly_schedule][:is_published] || 0
    }
    @section = Section.find(params[:section_id])
    @weekly_schedule = WeeklySchedule.find(params[:weekly_schedule][:id])
    authorize! :update, @section

    if @weekly_schedule.update_attributes(schedule_attributes)
      flash[:notice] = "Successfully updated schedule."
    else
      flash[:error] = "There was an error updating the schedule: #{@weekly_schedule.errors.full_messages.join(", ")}"
    end
    date = @weekly_schedule.date
    redirect_to edit_weekly_section_schedule_path(
      :section_id => @section.id,
      :year => date.year,
      :month => date.month,
      :day => date.day
    )
  end
end
