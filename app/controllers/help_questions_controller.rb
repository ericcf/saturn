class HelpQuestionsController < ApplicationController

  before_filter :authenticate_user!, :except => :index

  def index
    @help_questions = HelpQuestion.all
  end

  def new
    @help_question = HelpQuestion.new
  end

  def create
    @help_question = HelpQuestion.new(params[:help_question])

    if @help_question.save
      return(redirect_to help_questions_path)
    end
    render :new
  end

  def edit
    @help_question = HelpQuestion.find(params[:id])
    authorize! :update, @help_question

  rescue ActiveRecord::RecordNotFound
    flash[:error] = "Error: requested question not found"
    redirect_to help_questions_path
  end

  def update
    @help_question = HelpQuestion.find(params[:id])
    authorize! :update, @help_question

    if @help_question.update_attributes(params[:help_question])
      return(redirect_to help_questions_path)
    end
    render :edit

  rescue ActiveRecord::RecordNotFound
    flash[:error] = "Error: requested question not found"
    redirect_to help_questions_path
  end

  def destroy
    @help_question = HelpQuestion.find(params[:id])
    authorize! :destroy, @help_question

    if @help_question.destroy
      flash[:notice] = "Successfully deleted question"
    else
      flash[:error] = "Error: failed to delete question"
    end
    return(redirect_to help_questions_path)

  rescue ActiveRecord::RecordNotFound
    flash[:error] = "Error: requested question not found"
    redirect_to help_questions_path
  end
end
