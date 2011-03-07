class AssignmentRequestsController < ApplicationController
  include SectionResourceController

  before_filter :authenticate_user!, :except => [:index, :new, :create]

  def index
    @assignment_requests = @section.assignment_requests
  end

  def new
    @assignment_request = AssignmentRequest.new
  end

  def create
    @assignment_request = AssignmentRequest.new(params[:assignment_request])

    if @assignment_request.save
      flash[:notice] = "Successfully submitted assignment request"
      return(redirect_to section_assignment_requests_path(@section))
    end
    flash.now[:error] = "Unable to submit assignment request: #{@assignment_request.errors.full_messages.join(", ")}"
    render :new
  end

  def edit
    authorize! :manage, @section
    @assignment_request = @section.assignment_requests.find(params[:id])

  rescue ActiveRecord::RecordNotFound
    flash[:error] = "Error: requested assignment request not found"
    redirect_to section_assignment_requests_path(@section)
  end

  def update
    authorize! :manage, @section
    @assignment_request = @section.assignment_requests.find(params[:id])

    if @assignment_request.update_attributes(params[:assignment_request])
      flash[:notice] = "Successfully updated assignment request"
      return(redirect_to section_assignment_requests_path(@section))
    end
    flash.now[:error] = "Unable to update assignment request: #{@assignment_request.errors.full_messages.join(", ")}"
    render :edit

  rescue ActiveRecord::RecordNotFound
    flash[:error] = "Error: requested assignment request not found"
    redirect_to section_assignment_requests_path(@section)
  end

  def approve
    authorize! :manage, @section
    @assignment_request = @section.assignment_requests.find(params[:id])

    if @assignment_request.approve!
      flash[:notice] = "Successfully approved assignment request"
    else
      flash[:error] = "Unable to approve assignment request: #{@assignment_request.errors.full_messages.join(", ")}"
    end
    redirect_to section_assignment_requests_path(@section)
  end
end
