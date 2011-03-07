class AssignmentRequestObserver < ActiveRecord::Observer

  def after_create(assignment_request)
    UserNotifications.new_assignment_request(assignment_request).deliver
  end
end
