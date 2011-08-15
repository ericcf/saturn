class PhysicianNotifications < ActionMailer::Base

  default :from => APP_CONFIG["from_email"]

  def assignment_request_approved(request)
    @shift_title = request.shift_title
    @date_range = [
      request.start_date.to_s(:short_with_weekday),
      request.end_date && request.end_date.to_s(:short_with_weekday)
    ].compact.join(" - ")
    @requester = request.requester

    mail :to => request.requester.primary_email, :subject => I18n.t('actionmailer.physician_notifications.assignment_request_approved.subject')
  end
end
