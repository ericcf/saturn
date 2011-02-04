class ConferencesController < ApplicationController

  def index
    @date = params[:date] && Date.civil(params[:date][:year].to_i, params[:date][:month].to_i, params[:date][:day].to_i) || Date.today
    @conferences = Conference.occur_on(@date).order(:starts_at)

    respond_to do |format|
      format.html
    end
  end

  def show
    @conference = Conference.find(params[:id])

    respond_to do |format|
      format.html
    end
  end
end
