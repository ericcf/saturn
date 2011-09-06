Transform /^table:Physician,Section$/ do |table|
  table.hashes.map do |hash|
    physician = Physician.name_like(hash["Physician"]).first
    section = Section.find_by_title hash["Section"]
    { :physician_id => physician.id, :section => section }
  end
end

Given /^(?:a )?section memberships? exists? with the following attributes:$/ do |groups|
  groups.each do |attributes|
    FactoryGirl.create(:section_membership,
                       :physician_id => attributes[:physician_id],
                       :section => attributes[:section])
  end
end
