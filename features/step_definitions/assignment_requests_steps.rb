Given /^a section has a member physician and an associated shift$/ do
  Given %{a section}
    And %{a physician}
    And %{the physician is a member of the section}
    And %{a shift}
    And %{the shift is associated with the section}
end

When /^I view the assignment requests for the section$/ do
  Given %{a section has a member physician and an associated shift}
    And %{an assignment request for the physician and the shift}
  visit section_assignment_requests_path(@section)
end

When /^I prepare to manage assignment requests for the section$/ do
  Given %{I am an authenticated section administrator for the section}
  @current_user = @user
    And %{an assignment request for the physician and the shift}
  visit section_assignment_requests_path(@section)
end

When /^a user submits a new assignment request$/ do
  Given %{a section has a member physician and an associated shift}
    And %{I prepare to manage assignment requests for the section}
    And %{an assignment request for the physician and the shift}
end

When /^I submit a new assignment request$/ do
  visit new_section_assignment_request_path(@section)
  if page.has_selector? "select [id=assignment_request_requester_id]"
    select @physician.full_name, :from => "Requester"
  end
  select @shift.title, :from => "Shift"
  fill_in "Start date", :with => Date.today.to_s(:db)
  click_on "Create Assignment request"
end

Then /^I should have been notified about the new assignment request$/ do
  assert !@current_user.nil?
  Then %{"#{@current_user.email}" should have received an email with the subject "#{I18n.t 'actionmailer.user_notifications.new_assignment_request.subject', :name => @physician.full_name}"}
end

When /^I approve a pending assignment request$/ do
  Given %{a section has a member physician and an associated shift}
    And %{an assignment request for the physician and the shift}
  And %{I prepare to manage assignment requests for the section}
  within(".assignment_request:first") { click_on "Approve" }
  assert_equal AssignmentRequest::STATUS[:approved],
    AssignmentRequest.find(@assignment_request.id).status,
    "expected assignment request status to be 'approved'"
end

Then /^the physician should have been notified about her approved request$/ do
  assert AssignmentRequest.count == 1
  request = AssignmentRequest.first
  assert request.status == AssignmentRequest::STATUS[:approved]
  physician = request.requester
  Then %{"#{physician.primary_email}" should have received an email with the subject "#{I18n.t 'actionmailer.physician_notifications.assignment_request_approved.subject'}"}
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

Then /^I should see the assignment request listed$/ do
  page.should have_content @assignment_request.requester.short_name
end
