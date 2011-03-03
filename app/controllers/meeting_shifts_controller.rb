class MeetingShiftsController < ApplicationController
  include SectionResourceController

  before_filter :authenticate_user!
  before_filter :authorize_action

  def new
    @meeting_shift = MeetingShift.new
  end

  def create
    @meeting_shift = MeetingShift.new(params[:meeting_shift])
    if @section.meeting_shifts << @meeting_shift
      flash[:notice] = "Successfully created meeting shift"
      return(redirect_to section_shifts_path(@section))
    end
    flash.now[:error] = "Unable to create meeting shift: #{@meeting_shift.errors.full_messages.join(", ")}"
    render :new
  end

  def edit
    @meeting_shift = @section.meeting_shifts.find(params[:id])

  rescue ActiveRecord::RecordNotFound
    flash[:error] = "Error: requested meeting shift not found"
    redirect_to section_shifts_path(@section)
  end

  def update
    @meeting_shift = @section.meeting_shifts.readonly(false).find(params[:id])

    meeting_shift_attributes = params[:meeting_shift] || {}
    meeting_shift_attributes[:section_ids] ||= []
    meeting_shift_attributes[:section_ids] << @section.id
    if @meeting_shift.update_attributes(meeting_shift_attributes)
      flash[:notice] = "Successfully updated meeting shift"
      return redirect_to(section_shifts_path(@section))
    end
    flash.now[:error] = "Unable to update meeting shift: #{@meeting_shift.errors.full_messages.join(", ")}"
    render :edit

  rescue ActiveRecord::RecordNotFound
    flash[:error] = "Error: requested meeting shift not found"
    redirect_to section_shifts_path(@section)
  end

  private

  def authorize_action
    authorize! :manage, @section
  end
end
