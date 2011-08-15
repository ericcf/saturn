Given /^a section$/ do
  @section ||= Section.create!(:title => "Body")
end

Given /^a second section$/ do
  @section_2 ||= Section.create!(:title => "Neuro")
end

Given /^an unpublished weekly schedule in the section$/ do
  @weekly_schedule = @section.weekly_schedules.create(
    :date => Date.today.at_beginning_of_week,
    :is_published => false
  ) || raise
end

Given /^a published weekly schedule in the section$/ do
  @weekly_schedule = @section.weekly_schedules.create(
    :date => Date.today.at_beginning_of_week,
    :is_published => true
  ) || raise
end

Given /^a physician$/ do
  @physician ||= Physician.first
end

Given /^an alias for the physician$/ do
  @physician_alias ||= PhysicianAlias.create!(:physician_id => @physician.id,
                                              :initials => "ZZ",
                                              :short_name => "M. Flen"
                                             )
end

Given /^the physician is a member of the section$/ do
  @section.memberships.create(:physician_id => @physician.id) || raise
  # refresh stale associations
  @section = Section.first
end

Given /^a shift$/ do
  @shift ||= Shift.create!(:title => "Conference")
end

Given /^the shift is associated with the section$/ do
  @section.shifts << @shift
  @section = Section.first
  @shift = Shift.first
end

Given /^the physician is assigned to the shift$/ do
  Assignment.create!(:shift => @shift,
                     :physician_id => @physician.id,
                     :date => Date.today
                    )
  # refresh stale associations
  @shift = Shift.first
end

Given /^There is a physician in a section with a published assignment$/ do
  Given %{a section}
    And %{a published weekly schedule in the section}
    And %{a physician}
    And %{the physician is a member of the section}
    And %{a shift}
    And %{the shift is associated with the section}
    And %{the physician is assigned to the shift}
end

Given /^a call shift$/ do
  @call_shift ||= CallShift.create!(:title => "Weekend Call")
end

Given /^the call shift is associated with the section$/ do
  @section.call_shifts << @call_shift
end

Given /^the physician is assigned to the call shift$/ do
  Assignment.create!(:shift => @call_shift,
                     :physician_id => @physician.id,
                     :date => Date.today
                    )
  # refresh stale associations
  @call_shift = CallShift.first
end

Given /^There is a physician in a section with a published call assignment$/ do
  Given %{a section}
    And %{a published weekly schedule in the section}
    And %{a physician}
    And %{the physician is a member of the section}
    And %{a call shift}
    And %{the call shift is associated with the section}
    And %{the physician is assigned to the call shift}
end

Given /^a shift tag$/ do
  @shift_tag ||= ShiftTag.create!(:section => @section, :title => "AM")
end

Given /^an assignment request for the physician and the shift$/ do
  @assignment_request ||=
    AssignmentRequest.create!(:requester_id => @physician.id,
                              :shift => @shift,
                              :start_date => Date.today
                             )
end
