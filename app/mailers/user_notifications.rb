class UserNotifications < ActionMailer::Base
  default :from => APP_CONFIG["from_email"]

  def new_vacation_request(request, recipients)
    @physician_name = request.requester.full_name
    @section_title = request.section.title
    @vacation_requests_url = section_vacation_requests_url(request.section)

    mail :to => recipients, :subject => "Saturn: New Vacation Request"
  end

  def new_meeting_request(request, recipients)
    @physician_name = request.requester.full_name
    @section_title = request.section.title
    @meeting_requests_url = section_meeting_requests_url(request.section)

    mail :to => recipients, :subject => "Saturn: New Meeting Request"
  end
end
