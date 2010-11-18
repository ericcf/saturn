class VacationRequestsController < ApplicationController
  include SectionResourceController

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
    @vacation_request = VacationRequest.new
  end

  def create
    @vacation_request = VacationRequest.new(params[:vacation_request])
    if @section.vacation_requests << @vacation_request
      return(redirect_to section_vacation_requests_path(@section))
    end
    render :new
  end

  def edit
    @vacation_request = @section.vacation_requests.find(params[:id])

  rescue ActiveRecord::RecordNotFound
    flash[:error] = "Error: requested vacation_request not found"
    redirect_to section_vacation_requests_path(@section)
  end

  def update
    @vacation_request = @section.vacation_requests.find(params[:id])
    if @vacation_request.update_attributes(params[:vacation_request])
      return(redirect_to section_vacation_request_path(@section, @vacation_request))
    end
    render :edit

  rescue ActiveRecord::RecordNotFound
    flash[:error] = "Error: requested vacation_request not found"
    redirect_to section_vacation_requests_path(@section)
  end

  def destroy
    @vacation_request = @section.vacation_requests.find(params[:id])
    if @vacation_request.destroy
      flash[:notice] = "Successfully deleted vacation_request"
    else
      flash[:error] = "Error: failed to delete vacation_request"
    end
    redirect_to section_vacation_requests_path(@section)

  rescue ActiveRecord::RecordNotFound
    flash[:error] = "Error: requested vacation_request not found"
    redirect_to section_vacation_requests_path(@section)
  end
end
