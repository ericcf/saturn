require 'date_helpers'
require 'tables'

class SchedulesController < ApplicationController

  include DateHelpers

  before_filter :authenticate_user!, :only => [:edit_weekly_section,
    :create_weekly_section, :update_weekly_section]

  def weekly_call
    @start_date = monday_of_week_with(params[:date])
    @dates = week_dates_beginning_with(@start_date)
    @schedules = WeeklySchedule.published.find_all_by_date(@start_date)
    @call_shifts = Shift.by_tag("Call")
    @call_assignments = Assignment.by_schedules_and_shifts(
      @schedules,
      @call_shifts
    ).includes(:physician => :names_alias)
    @notes = @call_assignments.map(&:public_note_details).compact
  end

  def show_weekly_section
    start_date = monday_of_week_with(params[:date])
    @dates = week_dates_beginning_with(start_date)
    @section = Section.find(params[:section_id])
    @shifts = @section.shifts.active_as_of(start_date).includes(:shift_tags)
    @schedule = @section.weekly_schedules.published.find_by_date(start_date) ||
      @section.weekly_schedules.build(:date => start_date)
    @assignments = @schedule.assignments.includes(:shift)
    @notes = @assignments.map(&:public_note_details).compact
    @view_mode = params[:view_mode]
    @schedule_view = case @view_mode.to_i
                     when 0, 1
                       physician_ids = @assignments.map(&:physician_id)
                       physicians = Physician.where(:id => physician_ids).
                         includes(:names_alias).
                         each_with_object({}) {|p, hsh| hsh[p.id] = p.short_name}
                       Tables::TabularData.new(:x => [@dates, :clone],
      :y => [@shifts, :id],
      :mapped_values => @assignments.group_by {|a| [a.date, a.shift_id]},
      :content_formatter => lambda { |assgnmnt| physicians[assgnmnt.physician_id] })
                     when 2
                       Tables::TabularData.new(:x => [@dates, :clone],
      :y => [@section.members, :id], 
      :mapped_values => @assignments.group_by {|a| [a.date, a.physician_id]},
      :content_formatter => lambda { |assgnmt| assgnmt.shift.title })
                     end
    respond_to do |format|
      format.html
      format.xls { render :xls => @assignments, :template => "schedules/weekly_section_schedule.xls", :layout => false }
    end
  end

  def edit_weekly_section
    date = params[:date] || [params[:year], params[:month], params[:day]].join("-")
    @week_start_date = monday_of_week_with(date)
    @week_dates = week_dates_beginning_with(@week_start_date)
    @section = Section.find(params[:section_id])
    @shifts = @section.shifts.active_as_of(@week_start_date)
    @weekly_schedule = WeeklySchedule.find_by_section_id_and_date(
      params[:section_id],
      @week_start_date
    ) || WeeklySchedule.new(
      :section_id => params[:section_id],
      :date => @week_start_date
    )
    authorize! :manage, @weekly_schedule
    @assignments = @weekly_schedule.assignments
    @grouped_people = @section.members_by_group
    @people_names = {}
    @grouped_people.each do |group_title, people|
      people.each { |p| @people_names[p.id] = p.short_name }
    end
  end

  def create_weekly_section
    schedule_attributes = params[:weekly_schedule].merge({
      :section_id => params[:section_id],
      :assignments_attributes => params[:assignments] || {}
    })
    @weekly_schedule = WeeklySchedule.new(schedule_attributes)
    authorize! :manage, @weekly_schedule
    if @weekly_schedule.save
      date = @weekly_schedule.date
      redirect_to edit_weekly_section_schedule_path(
        :section_id => params[:section_id],
        :year => date.year,
        :month => date.month,
        :day => date.day
      )
    else
      @week_start_date = Date.parse(params[:weekly_schedule][:date])
      @week_dates = week_dates_beginning_with(@week_start_date)
      @section = Section.find(params[:section_id])
      @grouped_people = @section.members_by_group
      @assignments = @weekly_schedule.assignments_including([:physician, :shift])
      flash[:error] = "There was an error creating the schedule: #{@weekly_schedule.errors.full_messages.join(", ")}"
      render :edit_weekly_section
    end
  end

  def update_weekly_section
    schedule_attributes = {
      :assignments_attributes => params[:assignments] || {}
    }
    @section = Section.find(params[:section_id])
    @weekly_schedule = WeeklySchedule.find(params[:weekly_schedule][:id])
    authorize! :update, @weekly_schedule
    @weekly_schedule.publish = params[:weekly_schedule][:publish]

    if @weekly_schedule.update_attributes(schedule_attributes)
      date = @weekly_schedule.date
      redirect_to edit_weekly_section_schedule_path(
        :section_id => @section.id,
        :year => date.year,
        :month => date.month,
        :day => date.day
      )
    end
  end
end
