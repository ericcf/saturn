class ShiftsController < ApplicationController
  include SectionResourceController

  before_filter :authenticate_user!
  before_filter :authorize_action

  def index
    @current_shifts = @section.active_shifts.
      find(:all, :include => :shift_tags)
    @retired_shifts = @section.retired_shifts_as_of(Date.today).
      find(:all, :include => :shift_tags)
  end

  def new
    @shift = Shift.new
  end

  def create
    @shift = Shift.new(params[:shift])
    if @section.shifts << @shift
      flash[:notice] = "Successfully created shift"
      return(redirect_to section_shifts_path(@section))
    end
    flash.now[:error] = "Unable to create shift: #{@shift.errors.full_messages.join(", ")}"
    render :new
  end

  def edit
    @shift = @section.shifts.find(params[:id])

  rescue ActiveRecord::RecordNotFound
    flash[:error] = "Error: requested shift not found"
    redirect_to section_shifts_path(@section)
  end

  def update
    @shift = @section.shifts.readonly(false).find(params[:id])

    shift_attributes = params[:shift] || {}
    shift_attributes[:section_ids] ||= []
    shift_attributes[:section_ids] << @section.id
    if @shift.update_attributes(shift_attributes)
      flash[:notice] = "Successfully updated shift"
      return redirect_to(section_shifts_path(@section))
    end
    flash.now[:error] = "Unable to update shift: #{@shift.errors.full_messages.join(", ")}"
    render :edit

  rescue ActiveRecord::RecordNotFound
    flash[:error] = "Error: requested shift not found"
    redirect_to section_shifts_path(@section)
  end

  private

  def authorize_action
    authorize! :manage, @section
  end
end
