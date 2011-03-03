class CallShiftsController < ApplicationController
  include SectionResourceController

  before_filter :authenticate_user!
  before_filter :authorize_action

  def new
    @call_shift = CallShift.new
  end

  def create
    @call_shift = CallShift.new(params[:call_shift])
    if @section.call_shifts << @call_shift
      flash[:notice] = "Successfully created call shift"
      return(redirect_to section_shifts_path(@section))
    end
    flash.now[:error] = "Unable to create call shift: #{@call_shift.errors.full_messages.join(", ")}"
    render :new
  end

  def edit
    @call_shift = @section.call_shifts.find(params[:id])

  rescue ActiveRecord::RecordNotFound
    flash[:error] = "Error: requested call shift not found"
    redirect_to section_shifts_path(@section)
  end

  def update
    @call_shift = @section.call_shifts.readonly(false).find(params[:id])

    call_shift_attributes = params[:call_shift] || {}
    call_shift_attributes[:section_ids] ||= []
    call_shift_attributes[:section_ids] << @section.id
    if @call_shift.update_attributes(call_shift_attributes)
      flash[:notice] = "Successfully updated call shift"
      return redirect_to(section_shifts_path(@section))
    end
    flash.now[:error] = "Unable to update call shift: #{@call_shift.errors.full_messages.join(", ")}"
    render :edit

  rescue ActiveRecord::RecordNotFound
    flash[:error] = "Error: requested call shift not found"
    redirect_to section_shifts_path(@section)
  end

  private

  def authorize_action
    authorize! :manage, @section
  end
end
