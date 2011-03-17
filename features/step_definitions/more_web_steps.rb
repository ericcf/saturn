When /^I fill in "([^"]*)" with today's date$/ do |field|
  When "I fill in \"#{field}\" with \"#{Date.today.to_s(:rfc822)}\""
end

When /^(?:|I )click "([^"]*)"$/ do |selector|
  find(selector).click
end

Then /^(?:|I )should see the ajax result \/([^\/]*)\/(?: within "([^"]*)")?$/ do |regexp, selector|
  regexp = Regexp.new(regexp)
  with_scope(selector) do
    begin
      page.should have_xpath('//*', :text => regexp)
    rescue Selenium::WebDriver::Error::ObsoleteElementError
      page.should have_xpath('//*', :text => regexp)
    end
  end
end

When /^(?:|I )focus on field "([^"]*)"$/ do |css_class_name|
  page.execute_script("document.getElementsByClassName('" + css_class_name + "')[0].focus();")
end

When /^(?:|I )update text field "([^"]*)" with "([^"]*)"$/ do |css_class_name, text|
  page.execute_script(<<JS
    var input = document.getElementsByClassName("#{css_class_name}")[0];
    input.value = "#{text}";
    var changeEvent = document.createEvent("HTMLEvents");
    changeEvent.initEvent("change", true, false);
    input.dispatchEvent(changeEvent);
JS
  )
end
