class VacationRequestsController < ApplicationController
  include SectionResourceController

  before_filter :authenticate_user!, :except => [:index, :show, :new, :create]

  def index
    @vacation_requests = @section.vacation_requests
  end

  def show
    @vacation_request = @section.vacation_requests.find(params[:id])

  rescue ActiveRecord::RecordNotFound
    flash[:error] = "Error: requested vacation_request not found"
    redirect_to section_vacation_requests_path
  end

  def new
    unless @section.vacation_shift.nil?
      @vacation_request = VacationRequest.new
    else
      flash[:error] = "Unable to add vacation requests at this time, please notify your administrator."
      redirect_to section_vacation_requests_path(@section)
    end
  end

  def create
    attributes = params[:vacation_request].merge({
      :shift => @section.vacation_shift
    })
    @vacation_request = VacationRequest.new(attributes)
    if @section.vacation_requests << @vacation_request
      UserNotifications.new_vacation_request(@vacation_request, @section.administrators.map(&:email)).deliver
      flash[:notice] = "Successfully submitted vacation request"
      return(redirect_to section_vacation_requests_path(@section))
    end
    flash.now[:error] = "Unable to submit vacation request: #{@vacation_request.errors.full_messages.join(", ")}"
    render :new
  end

  def edit
    authorize! :manage, @section
    @vacation_request = @section.vacation_requests.find(params[:id])

  rescue ActiveRecord::RecordNotFound
    flash[:error] = "Error: requested vacation_request not found"
    redirect_to section_vacation_requests_path(@section)
  end

  def update
    authorize! :manage, @section
    @vacation_request = @section.vacation_requests.find(params[:id])
    if @vacation_request.update_attributes(params[:vacation_request])
      flash[:notice] = "Successfully updated vacation request"
      return(redirect_to section_vacation_requests_path(@section))
    end
    flash.now[:error] = "Unable to update vacation request: #{@vacation_request.errors.full_messages.join(", ")}"
    render :edit

  rescue ActiveRecord::RecordNotFound
    flash[:error] = "Error: requested vacation_request not found"
    redirect_to section_vacation_requests_path(@section)
  end

  def approve
    authorize! :manage, @section
    @vacation_request = @section.vacation_requests.find(params[:id])
    if @vacation_request.approve
      flash[:notice] = "Successfully approved vacation request"
    else
      flash[:error] = "Unable to approve vacation request: #{@vacation_request.errors.full_messages.join(", ")}"
    end
    redirect_to section_vacation_requests_path(@section)
  end
end
