class ShiftTagsController < ApplicationController

  before_filter :authenticate_user!
  before_filter :find_section

  def index
    @shift_tags = @section.shift_tags
  end

  def show
    @shift_tag = @section.shift_tags.find(params[:id])

  rescue ActiveRecord::RecordNotFound
    flash[:error] = "Error: requested shift tag not found"
    redirect_to section_shift_tags_path(@section)
  end

  def new
    @shift_tag = ShiftTag.new
  end

  def create
    @shift_tag = ShiftTag.new(params[:shift_tag])
    if @section.shift_tags << @shift_tag
      return(redirect_to section_shift_tags_path(@section))
    end
    flash[:error] = "Error: could not create category (#{@shift_tag.errors.full_messages.join(", ")})"
    render :new
  end

  def edit
    @shift_tag = @section.shift_tags.find(params[:id])

  rescue ActiveRecord::RecordNotFound
    flash[:error] = "Error: requested shift tag not found"
    redirect_to section_shift_tags_path(@section)
  end

  def update
    @shift_tag = @section.shift_tags.find(params[:id])
    if @shift_tag.update_attributes(params[:shift_tag])
      return(redirect_to section_shift_tag_path(@section, @shift_tag))
    end
    render :edit

  rescue ActiveRecord::RecordNotFound
    flash[:error] = "Error: requested shift tag not found"
    redirect_to section_shift_tags_path(@section)
  end

  def destroy
    @shift_tag = @section.shift_tags.find(params[:id])
    if @shift_tag.destroy
      flash[:notice] = "Successfully deleted shift tag"
    else
      flash[:error] = "Error: failed to delete shift tag"
    end
    redirect_to section_shift_tags_path(@section)

  rescue ActiveRecord::RecordNotFound
    flash[:error] = "Error: requested shift tag not found"
    redirect_to section_shift_tags_path(@section)
  end

  def search
    render :json => @section.shift_tags.title_like(params[:term]).map(&:title)
  end

  private

  def find_section
    section_id = params[:section_id]
    return(redirect_to(sections_path)) unless section_id
    @section = Section.find(section_id)
  end
end
