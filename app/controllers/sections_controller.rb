class SectionsController < ApplicationController

  before_filter :authenticate_user!, :except => :index

  def index
    @sections = Section.all
  end

  def new
    @section = Section.new
  end

  def create
    @section = Section.new(params[:section])

    if @section.save
      redirect_to section_memberships_path(@section)
    else
      render :new
    end
  end

  def edit
    @section = Section.find(params[:id])

  rescue ActiveRecord::RecordNotFound
    flash[:error] = "Error: requested section not found"
    redirect_to sections_path
  end

  def update
    @section = Section.find(params[:id])

    if @section.update_attributes(params[:section])
      redirect_to(params[:redirect_path] || section_path(@section))
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

  def search_shift_tags
    @section = Section.find(params[:id])
    render :json => @section.shift_tags.label_like(params[:term]).map(&:label)
  end
end
