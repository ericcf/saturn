class MeetingRequestsController < ApplicationController
  include SectionResourceController

  before_filter :authenticate_user!, :except => [:index, :show, :new, :create]

  def index
    @meeting_requests = @section.meeting_requests
  end

  def show
    @meeting_request = @section.meeting_requests.find(params[:id])

  rescue ActiveRecord::RecordNotFound
    flash[:error] = "Error: requested meeting_request not found"
    redirect_to section_meeting_requests_path
  end

  def new
    unless @section.meeting_shift.nil?
      @meeting_request = MeetingRequest.new
    else
      flash[:error] = "Unable to add meeting requests at this time, please notify your administrator."
      redirect_to section_meeting_requests_path(@section)
    end
  end

  def create
    attributes = params[:meeting_request].merge({
      :shift => @section.meeting_shift
    })
    @meeting_request = MeetingRequest.new(attributes)
    if @section.meeting_requests << @meeting_request
      UserNotifications.new_meeting_request(@meeting_request, @section.administrators.map(&:email)).deliver
      flash[:notice] = "Successfully submitted meeting request"
      return(redirect_to section_meeting_requests_path(@section))
    end
    flash.now[:error] = "Unable to submit meeting request: #{@meeting_request.errors.full_messages.join(", ")}"
    render :new
  end

  def edit
    authorize! :manage, @section
    @meeting_request = @section.meeting_requests.find(params[:id])

  rescue ActiveRecord::RecordNotFound
    flash[:error] = "Error: requested meeting_request not found"
    redirect_to section_meeting_requests_path(@section)
  end

  def update
    authorize! :manage, @section
    @meeting_request = @section.meeting_requests.find(params[:id])
    if @meeting_request.update_attributes(params[:meeting_request])
      flash[:notice] = "Successfully updated meeting request"
      return(redirect_to section_meeting_requests_path(@section))
    end
    flash.now[:error] = "Unable to update meeting request: #{@meeting_request.errors.full_messages.join(", ")}"
    render :edit

  rescue ActiveRecord::RecordNotFound
    flash[:error] = "Error: requested meeting_request not found"
    redirect_to section_meeting_requests_path(@section)
  end

  def approve
    authorize! :manage, @section
    @meeting_request = @section.meeting_requests.find(params[:id])
    if @meeting_request.approve
      flash[:notice] = "Successfully approved meeting request"
    else
      flash[:error] = "Unable to approve meeting request: #{@meeting_request.errors.full_messages.join(", ")}"
    end
    redirect_to section_meeting_requests_path(@section)
  end
end
