class AssignmentsController < ApplicationController

  include SectionResourceController

  def index
    schedule = @section.weekly_schedules.include_dates([Date.parse(params[:date])]).first
    respond_to do |format|
      format.json do
        render :json => schedule.assignments.
          to_json(:only => [:id, :physician_id, :shift_id, :date])
      end
    end
  end
end
