Then /^I should see an Excel file$/ do
  Capybara.current_session.response_headers["Content-Type"].
    should =~ /#{Mime::XLS}/
end
