require 'date_helpers'

class PhysiciansController < ApplicationController

  include DateHelpers

  def index
    @physicians = Physician.section_members.includes(:groups).
      paginate(:page => params[:page])
  end

  def search
    unless params[:query].blank?
      @query = params[:query]
      @physicians = Physician.section_members.name_like(params[:query]).
        paginate(:page => params[:page], :per_page => 15)
      @dates = (Date.today..Date.today+6.days).entries
      @assignments = Assignment.published.
        where(:physician_id => @physicians.map(&:id)).
        date_in_range(@dates.first, @dates.last).
        includes(:shift)
    end
  end

  def schedule
    start_date = params[:date].blank? ? Date.today : Date.civil(params[:date][:year].to_i, params[:date][:month].to_i, params[:date][:day].to_i)
    @dates = week_dates_beginning_with(start_date)
    find_physician
    @assignments = @physician.assignments.
      includes(:weekly_schedule, :shift).
      published.
      find_all_by_date(@dates)
    @assignments_by_section = @assignments.group_by do |assignment|
      assignment.weekly_schedule.section
    end

    respond_to do |format|
      format.html
      format.ics { render :ics => "schedule.ics", :layout => false }
    end

  rescue ActiveRecord::RecordNotFound
    flash[:error] = "Error: requested physician not found"
    redirect_to physicians_path
  end

  private

  def find_physician
    @physician = Physician.find(params[:id])
  end
end
