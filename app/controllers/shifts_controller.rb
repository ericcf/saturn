class ShiftsController < ApplicationController

  before_filter :find_section

  def index
    @current_shifts = @section.shifts.active_as_of(Date.today).
      find(:all, :include => :shift_tags)
    @retired_shifts = @section.shifts.retired_as_of(Date.today).
      find(:all, :include => :shift_tags)
  end

  def show
    @shift = @section.shifts.find(params[:id])

  rescue ActiveRecord::RecordNotFound
    flash[:error] = "Error: requested shift not found"
    redirect_to section_shifts_path
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

  def edit
    @shift = @section.shifts.find(params[:id])

  rescue ActiveRecord::RecordNotFound
    flash[:error] = "Error: requested shift not found"
    redirect_to section_shifts_path(@section)
  end

  def update
    @shift = @section.shifts.find(params[:id])
    if @shift.update_attributes(params[:shift])
      return(redirect_to section_shift_path(@section, @shift))
    end
    render :edit

  rescue ActiveRecord::RecordNotFound
    flash[:error] = "Error: requested shift not found"
    redirect_to section_shifts_path(@section)
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
end
