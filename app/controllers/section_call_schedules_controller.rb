class SectionCallSchedulesController < ApplicationController

  respond_to :json

  def index
    date = Date.today
    call_schedules = Section.all.map do |section|
      ::Logical::SectionCallSchedule.new(
        :section_id => section.id,
        :date => date
      )
    end
    respond_with(call_schedules)
  end
end
