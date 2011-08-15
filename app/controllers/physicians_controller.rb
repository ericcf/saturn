require 'saturn/dates'

class PhysiciansController < ApplicationController

  include Saturn::Dates

  def index
    @physicians = Physician.all
  end

  def search
    unless params[:query].blank?
      @query = params[:query]
      @physicians = Physician.name_like(params[:query])
      start_date = params[:date] ? Date.parse(params[:date]) : Date.today.at_beginning_of_week
      @dates = (start_date..start_date + 6.days).to_a
      schedules = WeeklySchedule.published.include_dates(@dates)
      @assignments = schedules.map do |schedule|
        schedule.assignments.where(:physician_id => @physicians.map(&:id)).
          includes(:shift)
      end.flatten
    end
  end

  def schedule
    start_date = params[:date].blank? ? Date.today.at_beginning_of_week : Date.civil(params[:date][:year].to_i, params[:date][:month].to_i, params[:date][:day].to_i)
    find_physician
    @schedule = ::Logical::PhysicianSchedule.new(:physician => @physician,
      :start_date => start_date,
      :number_of_days => 28
    )

    respond_to do |format|
      format.html
      format.ics { render :ics => "schedule.ics", :layout => false }
    end

  rescue ActiveResource::ResourceNotFound
    flash[:error] = "Error: requested physician not found"
    redirect_to physicians_path
  end

  private

  def find_physician
    @physician = Physician.find(params[:id])
  end
end
