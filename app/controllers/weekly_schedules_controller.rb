require 'date_helpers'

class WeeklySchedulesController < ApplicationController
  include SectionResourceController
  include DateHelpers

  before_filter :authenticate_user!, :only => [:edit, :create]

  def show
    @weekly_schedules = @section.weekly_schedules
  end

  def edit
    authorize! :update, @section
    respond_to do |format|
      format.html
      format.json do
        start_date = monday_of_week_with(params[:date])
        @weekly_schedule = WeeklySchedule.find_by_section_id_and_date(
          @section.id,
          start_date
        ) || WeeklySchedule.new(
          :section_id => @section.id,
          :date => start_date
        )
        render :json => @weekly_schedule.to_json
      end
    end
  end

  # all POSTs are mapped here, and could be create or update actions
  def create
    authorize! :update, @section
    schedule_params = ActiveSupport::JSON.decode(params[:weekly_schedule])
    start_date = schedule_params["date"]
    @weekly_schedule = WeeklySchedule.find_by_section_id_and_date(
      @section.id,
      start_date
    ) || WeeklySchedule.create(
      :section_id => @section.id,
      :date => start_date
    )
    schedule_attributes = {
      :assignments_attributes => schedule_params["assignments"] || [],
      :shift_week_notes_attributes => schedule_params["shift_week_notes_attributes"] || [],
      :is_published => schedule_params["is_published"] || 0
    }
    @weekly_schedule.update_attributes(schedule_attributes)
    unless @weekly_schedule.errors.any?
      # used to provide an accurate last update date
      @weekly_schedule.touch
      # ensures that relations are fresh for serialization
      @weekly_schedule = WeeklySchedule.find(@weekly_schedule.id)
    end
    render :json => @weekly_schedule.to_json(:only_delta_attributes => true)
  end
end
