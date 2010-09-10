class ReportsController < ApplicationController

  before_filter :find_section

  def shift_totals
    @start_date = params[:start_date] ? Date.parse(params[:start_date]) : Date.today.at_beginning_of_month
    @end_date = params[:end_date] ? Date.parse(params[:end_date]) : Date.today
    people_by_group = @section.members_by_group
    shifts = @section.shifts.active_as_of(@start_date)
    shift_tags = @section.shift_tags
    assignments = Assignment.date_in_range(@start_date, @end_date).
      find_all_by_shift_id(shifts.map(&:id), :include => :shift)
    @report = ShiftsReport.new(assignments, shifts, shift_tags, people_by_group)

    respond_to do |format|
      format.html
      format.xls { render :xls => @report, :layout => false }
    end
  end

  def section_person_shift_totals
    find_person
    @start_date = params[:start_date] ? Date.parse(params[:start_date]) : Date.today.at_beginning_of_month
    @end_date = params[:end_date] ? Date.parse(params[:end_date]) : Date.today
    assignments = Assignment.all(:conditions => ["person_id = ? and date >= ? and date <= ?", @person.id, @start_date, @end_date])
    @shifts = Shift.find(assignments.map(&:shift_id).uniq)
    @assignment_by_shift_and_date = assignments.each_with_object({}) do |assignment, hsh|
      hsh[[assignment.shift, assignment.date]] = assignment
    end
  end

  private

  def find_section
    section_id = params[:section_id]
    return(redirect_to(sections_path)) unless section_id
    @section = Section.find(section_id)
  end

  def find_person
    person_id = params[:person_id]
    return(redirect_to(section_shift_totals_path(@section))) unless person_id
    @person = @section.memberships.find_by_person_id(person_id).person
  end
end
