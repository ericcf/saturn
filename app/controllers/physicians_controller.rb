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
    start_date = monday_of_week_with(params[:date])
    @dates = week_dates_beginning_with(start_date)
    @physician = Physician.find(params[:id])
    @assignments = @physician.assignments.published.where(:date => @dates).
      includes(:weekly_schedule, :shift)
    @assignments_by_section = @assignments.group_by{|a|a.weekly_schedule.section}

    respond_to do |format|
      format.html
      format.ics { render :ics => "personal_schedule.ics", :layout => false }
    end

  rescue ActiveRecord::RecordNotFound
    flash[:error] = "Error: requested physician not found"
    redirect_to physicians_path
  end
end
