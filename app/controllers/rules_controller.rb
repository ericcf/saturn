class RulesController < ApplicationController

  before_filter :find_section

  def show
    @weekly_shift_duration_rule = @section.weekly_shift_duration_rule
    @daily_shift_count_rules = @section.daily_shift_count_rules
  end

  def edit
    @weekly_shift_duration_rule = @section.weekly_shift_duration_rule ||
      @section.build_weekly_shift_duration_rule
    @daily_shift_count_rules = []
    @section.shift_tags.includes(:daily_shift_count_rule).each do |shift_tag|
      @daily_shift_count_rules << (shift_tag.daily_shift_count_rule ||
        shift_tag.build_daily_shift_count_rule)
    end
  end

  def update
    if @section.update_attributes(params[:section])
      return(redirect_to(section_rules_path(@section)))
    end
    render :edit
  end

  private

  def find_section
    section_id = params[:section_id]
    return(redirect_to(sections_path)) unless section_id
    @section = Section.find(section_id)
  end
end