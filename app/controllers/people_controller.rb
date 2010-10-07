require 'date_helpers'

class PeopleController < ApplicationController

  include DateHelpers

  before_filter :authenticate_user!, :only => [:edit, :update]

  def index
    @people = Person.includes([:names_alias, :sections, :groups])
  end

  def edit
    @person = Person.find(params[:id])
    authorize! :update, @person
    @person.build_names_alias unless @person.names_alias

  rescue ActiveRecord::RecordNotFound
    flash[:error] = "Error: requested person not found"
    redirect_to people_path
  end

  def update
    @person = Person.find(params[:id])
    authorize! :update, @person

    if @person.update_attributes(params[:person])
      return(redirect_to people_path)
    end
    render :edit

  rescue ActiveRecord::RecordNotFound
    flash[:error] = "Error: requested person not found"
    redirect_to people_path
  end

  def schedule
    start_date = monday_of_week_with(params[:date])
    @dates = week_dates_beginning_with(start_date)
    @person = Person.find(params[:id])
    @assignments = Assignment.find_all_by_person_id_and_date(@person.id, @dates, :include => [:weekly_schedule, :shift])
    @assignments_by_section = @assignments.group_by{|a|a.weekly_schedule.section}

    respond_to do |format|
      format.html
      format.ics { render :ics => "personal_schedule.ics", :layout => false }
    end

  rescue ActiveRecord::RecordNotFound
    flash[:error] = "Error: requested person not found"
    redirect_to people_path
  end
end
