When /^I prepare to manage assignment requests for the section "([^"]*)"$/ do |section_title|
  Given %{there is a user "harold@foo.com" with password "secret"}
    And %{User "harold@foo.com" is a section administrator for the "#{section_title}" section}
    And %{I sign in as user "harold@foo.com" with password "secret"}
  @current_user = User.find_by_email("harold@foo.com")
  section = Section.find_by_title(section_title)
  visit section_assignment_requests_path(section)
end

When /^an assignment request is submitted$/ do
  Given %{a physician "Julia Child" in the section "MSK"}
    And %{a shift "Kitchen" in the section "MSK"}
    And %{I prepare to manage assignment requests for the section "MSK"}
  physician = Physician.find_by_given_name_and_family_name("Julia", "Child")
  shift = Shift.find_by_title("Kitchen")
  AssignmentRequest.create!(:requester_id => physician.id, :shift => shift,
    :start_date => Date.today)
end

Then /^I should have been notified about the new assignment request$/ do
  assert !@current_user.nil?
  Then %{"#{@current_user.email}" should have received an email with the subject "#{I18n.t 'actionmailer.user_notifications.new_assignment_request.subject', :name => "Julia Child"}"}
end

When /^I approve a pending assignment request$/ do
  Given %{a physician "Mike Wazowski" in the section "Tongue"}
    And %{a shift "Conference" in the section "Tongue"}
  physician = Physician.find_by_given_name_and_family_name("Mike", "Wazowski")
  shift = Shift.find_by_title("Conference")
  request = AssignmentRequest.create!(:requester_id => physician.id,
    :shift => shift, :start_date => Date.today)
  And %{I prepare to manage assignment requests for the section "Tongue"}
  within(".assignment_request:first") { click_on "Approve" }
  assert AssignmentRequest.find(request.id).status == AssignmentRequest::STATUS[:approved]
end

Then /^the physician should have been notified about her approved request$/ do
  assert AssignmentRequest.count == 1
  request = AssignmentRequest.first
  assert request.status == AssignmentRequest::STATUS[:approved]
  physician = request.requester
  Then %{"#{physician.work_email}" should have received an email with the subject "#{I18n.t 'actionmailer.physician_notifications.assignment_request_approved.subject'}"}
end

Then /^assignments should have been created for the approved request$/ do
  assert AssignmentRequest.count == 1
  request = AssignmentRequest.first
  assert request.status == AssignmentRequest::STATUS[:approved]
  request.dates.each do |date|
    assert !Assignment.where(:date => date,
      :physician_id => request.requester_id,
      :shift_id => request.shift_id
    ).blank?
  end
end
