class ReportsController < ApplicationController
  include SectionResourceController

  def shift_totals
    @start_date = params[:start_date] ? Date.parse(params[:start_date]) : Date.today.at_beginning_of_month
    @end_date = params[:end_date] ? Date.parse(params[:end_date]) : Date.today
    @shifts = @section.shifts.active_as_of(@start_date)
    @shift_tags = @section.shift_tags
    @physicians_by_group = @section.members_by_group
    assignments = @section.assignments.published.
      date_in_range(@start_date, @end_date).includes(:shift)
    @totals_by_physician_and_shift = assignments.
      each_with_object({}) do |assignment, hsh|
        key = [assignment.physician_id, assignment.shift_id]
        hsh[key] = (hsh[key] ||= 0.0) + assignment.fixed_duration
      end
    @totals_by_group_and_shift = {}
    @totals_by_physician_and_tag = {}
    @totals_by_physician_and_shift.each do |key, total|
      physician_id, shift_id = key
      @physicians_by_group.each do |group_name, physicians|
        if physicians.map(&:id).include?(physician_id)
          key = [group_name, shift_id]
          @totals_by_group_and_shift[key] ||= 0.0
          @totals_by_group_and_shift[key] += total
        end
      end
      @shift_tags.each do |tag|
        if tag.shift_ids.include?(shift_id)
          key = [physician_id, tag.id]
          @totals_by_physician_and_tag[key] ||= 0.0
          @totals_by_physician_and_tag[key] += total
        end
      end
    end
    @totals_by_group_and_tag = {}
    @totals_by_physician_and_tag.each do |key, total|
      physician_id, tag_id = key
      @physicians_by_group.each do |group_name, physicians|
        if physicians.map(&:id).include?(physician_id)
          key = [group_name, tag_id]
          @totals_by_group_and_tag[key] ||= 0.0
          @totals_by_group_and_tag[key] += total
        end
      end
    end

    respond_to do |format|
      format.html
      format.xls { render :xls => @section, :layout => false,
        :template => "reports/section_report.xls" }
    end
  end

  def search_shift_totals
    @shift_totals_report = ShiftTotalsReport.new
  end

  def shift_totals_report
    @shift_totals_report = ShiftTotalsReport.new(params[:shift_totals_report])
    @shift_totals_report.section = @section

    unless @shift_totals_report.valid?
      flash.now[:error] = "Unable to generate report: #{@shift_totals_report.errors.full_messages.join(", ")}"
      render :search_shift_totals
    end
  end

  def shift_totals_by_day
    @shift_totals_report = ShiftTotalsReport.new(params[:shift_totals_report])
    @shift_totals_report.section = @section
    @shift = Shift.find(params[:shift_id])
  end

  def section_physician_shift_totals
    find_physician
    @start_date = params[:start_date] ? Date.parse(params[:start_date]) : Date.today.at_beginning_of_month
    @end_date = params[:end_date] ? Date.parse(params[:end_date]) : Date.today
    assignments = Assignment.where(:physician_id => @physician.id).
      date_in_range(@start_date, @end_date).
      includes(:shift).
      published
    @shifts = Shift.find(assignments.map(&:shift_id).uniq)
    @assignment_by_shift_and_date = assignments.each_with_object({}) do |assignment, hsh|
      hsh[[assignment.shift, assignment.date]] = assignment
    end
  end

  private

  def find_physician
    physician_id = params[:physician_id]
    return(redirect_to(section_shift_totals_path(@section))) unless physician_id
    @physician = @section.members.find(physician_id)
  end
end
