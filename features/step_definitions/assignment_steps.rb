Transform /^table:Physician,Shift,Date$/ do |table|
  table.hashes.map do |hash|
    physician = Physician.name_like(hash["Physician"]).first
    shift = Shift.find_by_title hash["Shift"]
    date = Chronic.parse hash["Date"]
    { :physician_id => physician.id, :shift => shift, :date => date }
  end
end

Given /^(?:an )?assignments? exists? with the following attributes:$/ do |groups|
  groups.each do |attributes|
    FactoryGirl.create(:assignment,
                       :physician_id => attributes[:physician_id],
                       :shift => attributes[:shift],
                       :date => attributes[:date])
  end
end
