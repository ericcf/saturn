require 'date_helpers'

class PeopleController < ApplicationController

  include DateHelpers

  def index
    @people = Person.
      all(:include => [:names_alias, :sections, :groups])
  end

  def show
    @person = Person.find(params[:id])

  rescue ActiveRecord::RecordNotFound
    flash[:error] = "Error: requested person not found"
    redirect_to people_path
  end

  def edit
    @person = Person.find(params[:id])
    @person.build_names_alias unless @person.names_alias

  rescue ActiveRecord::RecordNotFound
    flash[:error] = "Error: requested person not found"
    redirect_to people_path
  end

  def update
    @person = Person.find(params[:id])

    if @person.update_attributes(params[:person])
      return(redirect_to person_path(@person))
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
    assignments = Assignment.find_all_by_person_id_and_date(@person.id, @dates, :include => [:weekly_schedule, :shift])
    @assignments_by_section = assignments.group_by{|a|a.weekly_schedule.section}

  rescue ActiveRecord::RecordNotFound
    flash[:error] = "Error: requested person not found"
    redirect_to people_path
  end
end
