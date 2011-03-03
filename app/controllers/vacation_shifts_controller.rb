class VacationShiftsController < ApplicationController
  include SectionResourceController

  before_filter :authenticate_user!
  before_filter :authorize_action

  def new
    @vacation_shift = VacationShift.new
  end

  def create
    @vacation_shift = VacationShift.new(params[:vacation_shift])
    if @section.vacation_shifts << @vacation_shift
      flash[:notice] = "Successfully created vacation shift"
      return(redirect_to section_shifts_path(@section))
    end
    flash.now[:error] = "Unable to create vacation shift: #{@vacation_shift.errors.full_messages.join(", ")}"
    render :new
  end

  def edit
    @vacation_shift = @section.vacation_shifts.find(params[:id])

  rescue ActiveRecord::RecordNotFound
    flash[:error] = "Error: requested vacation shift not found"
    redirect_to section_shifts_path(@section)
  end

  def update
    @vacation_shift = @section.vacation_shifts.readonly(false).find(params[:id])

    vacation_shift_attributes = params[:vacation_shift] || {}
    vacation_shift_attributes[:section_ids] ||= []
    vacation_shift_attributes[:section_ids] << @section.id
    if @vacation_shift.update_attributes(vacation_shift_attributes)
      flash[:notice] = "Successfully updated vacation shift"
      return redirect_to(section_shifts_path(@section))
    end
    flash.now[:error] = "Unable to update vacation shift: #{@vacation_shift.errors.full_messages.join(", ")}"
    render :edit

  rescue ActiveRecord::RecordNotFound
    flash[:error] = "Error: requested vacation shift not found"
    redirect_to section_shifts_path(@section)
  end

  private

  def authorize_action
    authorize! :manage, @section
  end
end
