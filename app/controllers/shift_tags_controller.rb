class ShiftTagsController < ApplicationController
  include SectionResourceController

  before_filter :authenticate_user!
  before_filter :authorize_action

  def index
    @shift_tags = @section.shift_tags
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

  def search
    render :json => @section.shift_tags.title_like(params[:term]).map(&:title)
  end

  private

  def authorize_action
    authorize! :manage, @section
  end
end
