class AssignmentRequestObserver < ActiveRecord::Observer

  def after_create(request)
    UserNotifications.new_assignment_request(request).deliver
  end

  def after_update(request)
    if request.status == AssignmentRequest::STATUS[:approved]
      PhysicianNotifications.assignment_request_approved(request).deliver
    end
  end
end
