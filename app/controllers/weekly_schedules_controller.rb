require 'date_helpers'

class WeeklySchedulesController < ApplicationController
  include SectionResourceController
  include DateHelpers

  def show
    @weekly_schedules = @section.weekly_schedules
  end

  def edit
    respond_to do |format|
      format.html do
        @physicians_by_group = []
        @section.members_by_group.each do |group_title, physicians|
          @physicians_by_group << { "group_title" => group_title, "physicians" => physicians.map { |p| { "id" => p.id, "short_name" => p.short_name } } }
        end
      end

      format.json do
        start_date = monday_of_week_with(params[:date])
        @dates = week_dates_beginning_with(start_date)
        @shifts = @section.shifts.active_as_of(start_date)
        @weekly_schedule = WeeklySchedule.find_by_section_id_and_date(
          params[:section_id],
          start_date
        ) || WeeklySchedule.new(
          :section_id => params[:section_id],
          :date => start_date
        )
        rules_conflicts = RulesConflictSummary.new(:section => @section,
          :weekly_schedule => @weekly_schedule
        )

        render :json => [
          "{",
            "\"weekly_schedule\":",
              "{",
                @weekly_schedule.id ? "\"id\":#{@weekly_schedule.id}," : nil,
                "\"date\":",
                  "{",
                    "\"year\":#{@weekly_schedule.date.year},",
                    "\"month\":#{@weekly_schedule.date.month},",
                    "\"day\":#{@weekly_schedule.date.day}",
                  "},",
                "\"is_published\":#{@weekly_schedule.is_published},",
                "\"shift_weeks\":[#{@weekly_schedule.shift_weeks_json}],",
                "\"physicians\":#{@section.members.includes(:names_alias).map { |p| {"id"=>p.id,"short_name"=>p.short_name} }.to_json},",
                "\"dates\":#{@dates.map { |date| date.strftime("%a #{date.month}/#{date.day}") } },",
                "\"rules_conflicts\":#{rules_conflicts.to_json}",
                last_update_json,
              "}",
          "}"
        ].join("")
      end
    end
  end

  # all POSTs are mapped here, and could be create or update actions
  def create
    schedule_params = ActiveSupport::JSON.decode(params[:weekly_schedule])
    schedule_attributes = {
      :assignments_attributes => schedule_params["assignments"] || [],
      :is_published => schedule_params["is_published"] || 0
    }
    start_date = schedule_params["date"]
    @weekly_schedule = WeeklySchedule.find_by_section_id_and_date(
      params[:section_id],
      start_date
    ) || WeeklySchedule.new(
      :section_id => params[:section_id],
      :date => start_date
    )
    @weekly_schedule.update_attributes(schedule_attributes)
    # used to provide an accurate last update date
    @weekly_schedule.touch
    rules_conflicts = RulesConflictSummary.new(:section => @section,
      :weekly_schedule => @weekly_schedule
    )
    
    respond_to do |format|
      format.json { render :json => [
        "{",
          "\"weekly_schedule\":",
            "{",
              "\"id\":#{@weekly_schedule.id},",
              "\"is_published\":#{@weekly_schedule.is_published},",
              "\"shift_weeks\":[#{@weekly_schedule.shift_weeks_json}],",
              "\"rules_conflicts\":#{rules_conflicts.to_json}",
              last_update_json,
            "}",
        "}"
      ].join("") }
    end
  end

  private

  def last_update_json
    return "" unless last_update
    [
      ",\"last_update\":",
        "{",
          "\"year\":#{last_update.year},",
          "\"month\":#{last_update.month},",
          "\"day\":#{last_update.day},",
          "\"hour\":#{last_update.hour},",
          "\"minute\":#{last_update.min}",
        "}"
    ].join("")
  end

  def last_update
    return @last_update if @last_update
    return nil unless @weekly_schedule.updated_at
    last_assignment = @weekly_schedule.assignments.order("updated_at DESC").limit(1).first
    @last_update = [
      @weekly_schedule.updated_at,
      last_assignment ? last_assignment.updated_at : @weekly_schedule.updated_at
    ].max
  end
end
