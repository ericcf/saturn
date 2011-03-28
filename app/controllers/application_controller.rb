class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_locale

  def set_locale
    locale = nil
    if lang = request.env["HTTP_ACCEPT_LANGUAGE"]
      lang = lang.split(",").map { |l|
        l += ';q=1.0' unless l =~ /;q=\d+\.\d+$/
        l.split(';q=')
      }.first
      locale = lang.first.split("-").first
    else
      locale = I18n.default_locale
    end
    I18n.locale = locale
  end
end
