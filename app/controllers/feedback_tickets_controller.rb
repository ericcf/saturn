class FeedbackTicketsController < ApplicationController

  before_filter :authenticate_user!, :only => [:edit, :update, :destroy]

  def index
    @feedback_tickets = FeedbackTicket.all
  end

  def show
    @feedback_ticket = FeedbackTicket.find(params[:id])

  rescue ActiveRecord::RecordNotFound
    flash[:error] = "Error: requested ticket not found"
    redirect_to feedback_tickets_path
  end

  def new
    @feedback_ticket = FeedbackTicket.new
  end

  def create
    @feedback_ticket = FeedbackTicket.new(params[:feedback_ticket])

    if @feedback_ticket.save
      return(redirect_to feedback_tickets_path)
    end
    render :new
  end

  def edit
    @feedback_ticket = FeedbackTicket.find(params[:id])
    authorize! :update, @feedback_ticket

  rescue ActiveRecord::RecordNotFound
    flash[:error] = "Error: requested ticket not found"
    redirect_to feedback_tickets_path
  end

  def update
    @feedback_ticket = FeedbackTicket.find(params[:id])
    authorize! :update, @feedback_ticket

    if @feedback_ticket.update_attributes(params[:feedback_ticket])
      return(redirect_to feedback_tickets_path)
    end
    render :edit

  rescue ActiveRecord::RecordNotFound
    flash[:error] = "Error: requested ticket not found"
    redirect_to feedback_tickets_path
  end

  def destroy
    @feedback_ticket = FeedbackTicket.find(params[:id])
    authorize! :destroy, @feedback_ticket

    if @feedback_ticket.destroy
      flash[:notice] = "Successfully deleted ticket"
    else
      flash[:error] = "Error: failed to delete ticket"
    end
    return(redirect_to feedback_tickets_path)

  rescue ActiveRecord::RecordNotFound
    flash[:error] = "Error: requested ticket not found"
    redirect_to feedback_tickets_path
  end
end
