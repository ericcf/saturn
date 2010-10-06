class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :block_outsiders

  private

  def block_outsiders
    return true if Rails.env == "test"
    unless request.remote_ip =~ /^127.0.0.1$|^165.20/
      return(redirect_to("/404.html"))
    end
    return true
  end
end
