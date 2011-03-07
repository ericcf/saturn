When /^I fill in "([^"]*)" with today's date$/ do |field|
  When "I fill in \"#{field}\" with \"#{Date.today.to_s(:rfc822)}\""
end
