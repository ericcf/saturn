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
      schedules = WeeklySchedule.published.include_dates(@dates)
      dates_with_published_assignments = schedules.map(&:dates).flatten.sort.uniq
      @assignments = Assignment.
        where(:physician_id => @physicians.map(&:id), :date => dates_with_published_assignments)
    end
  end

  def schedule
    start_date = params[:date].blank? ? Date.today.at_beginning_of_week : Date.civil(params[:date][:year].to_i, params[:date][:month].to_i, params[:date][:day].to_i)
    find_physician
    @schedule = PhysicianSchedule.new(:physician => @physician, :start_date => start_date, :number_of_days => 28)

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
