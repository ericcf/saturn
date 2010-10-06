class FeedbackStatusesController < ApplicationController

  before_filter :authenticate_user!

  def index
    @feedback_statuses = FeedbackStatus.all
  end

  def show
    @feedback_status = FeedbackStatus.find(params[:id])

  rescue ActiveRecord::RecordNotFound
    flash[:error] = "Error: requested status not found"
    redirect_to feedback_statuses_path
  end

  def new
    authorize! :create, FeedbackStatus
    @feedback_status = FeedbackStatus.new
  end

  def create
    authorize! :create, FeedbackStatus
    @feedback_status = FeedbackStatus.new(params[:feedback_status])

    if @feedback_status.save
      return(redirect_to feedback_statuses_path)
    end
    render :new
  end

  def edit
    @feedback_status = FeedbackStatus.find(params[:id])
    authorize! :update, @feedback_status

  rescue ActiveRecord::RecordNotFound
    flash[:error] = "Error: requested status not found"
    redirect_to feedback_statuses_path
  end

  def update
    @feedback_status = FeedbackStatus.find(params[:id])
    authorize! :update, @feedback_status

    if @feedback_status.update_attributes(params[:feedback_status])
      return(redirect_to feedback_statuses_path)
    end
    render :edit

  rescue ActiveRecord::RecordNotFound
    flash[:error] = "Error: requested status not found"
    redirect_to feedback_statuses_path
  end

  def destroy
    @feedback_status = FeedbackStatus.find(params[:id])
    authorize! :destroy, @feedback_status

    if @feedback_status.destroy
      flash[:notice] = "Successfully deleted status"
    else
      flash[:error] = "Error: failed to delete status"
    end
    return(redirect_to feedback_statuses_path)

  rescue ActiveRecord::RecordNotFound
    flash[:error] = "Error: requested status not found"
    redirect_to feedback_statuses_path
  end
end
