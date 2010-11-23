class SectionsController < ApplicationController

  before_filter :authenticate_user!, :except => :index

  def index
    @sections = Section.all
  end

  def new
    @section = Section.new
    authorize! :create, @section
  end

  def create
    @section = Section.new(params[:section])
    authorize! :create, @section

    if @section.save
      flash[:notice] = "Successfully created section"
      return(redirect_to(section_memberships_path(@section)))
    end
    flash[:error] = "Unable to create section: #{@section.errors.full_messages.join(", ")}"
    render :new
  end

  def edit
    @section = Section.find(params[:id])
    authorize! :update, @section

  rescue ActiveRecord::RecordNotFound
    flash[:error] = "Error: requested section not found"
    redirect_to sections_path
  end

  def update
    @section = Section.find(params[:id])
    authorize! :update, @section

    if @section.update_attributes(params[:section])
      flash[:notice] = "Successfully updated section"
      redirect_to(params[:redirect_path] || section_memberships_path(@section))
    else
      flash[:error] = "Error: could not complete changes (#{@section.errors.full_messages.join(", ")})"
      render :edit
    end

  rescue ActiveRecord::RecordNotFound
    flash[:error] = "Error: requested section not found"
    redirect_to sections_path
  end

  def destroy
    @section = Section.find(params[:id])
    authorize! :destroy, @section

    if @section.destroy
      flash[:notice] = "Successfully deleted section"
    else
      flash[:error] = "Error: failed to delete section"
    end
    redirect_to sections_path

  rescue ActiveRecord::RecordNotFound
    flash[:error] = "Error: requested section not found"
    redirect_to sections_path
  end
end
