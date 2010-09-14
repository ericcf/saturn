class ShiftsController < ApplicationController

  before_filter :authenticate_user!
  before_filter :find_section
  before_filter :authorize_action

  def index
    @current_shifts = @section.shifts.active_as_of(Date.today).
      find(:all, :include => :shift_tags)
    @retired_shifts = @section.shifts.retired_as_of(Date.today).
      find(:all, :include => :shift_tags)
  end

  def new
    @shift = Shift.new
  end

  def create
    @shift = Shift.new(params[:shift])
    if @section.shifts << @shift
      return(redirect_to section_shifts_path(@section))
    end
    render :new
  end

  def destroy
    @shift = @section.shifts.find(params[:id])
    if @shift.destroy
      flash[:notice] = "Successfully deleted shift"
    else
      flash[:error] = "Error: failed to delete shift"
    end
    redirect_to section_shifts_path(@section)

  rescue ActiveRecord::RecordNotFound
    flash[:error] = "Error: requested shift not found"
    redirect_to section_shifts_path(@section)
  end

  private

  def find_section
    section_id = params[:section_id]
    return(redirect_to(sections_path)) unless section_id
    @section = Section.find(section_id)
  end

  def authorize_action
    authorize! :manage, @section
  end
end
