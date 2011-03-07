class UserNotifications < ActionMailer::Base

  default :from => APP_CONFIG["from_email"]

  def new_assignment_request(request)
    @physician_name = request.requester.full_name
    sections = request.sections
    @section_title = sections.first.title
    @assignment_requests_url = section_assignment_requests_url(sections.first)
    recipients = sections.map(&:administrator_emails).flatten.join(", ")

    mail :to => recipients, :subject => "Saturn: #{@physician_name} submitted a request"
  end
end
