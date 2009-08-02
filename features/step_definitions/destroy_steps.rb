Then /^I see the delete button in the page$/ do
  last_response.should have_selector("input[value=\"Delete\"][type=submit]")
end

When /I submit the delete form/ do
  delete "/examples/#{@ex.id}"
end

Then /^the example no longer exists$/ do
  lambda { Example.find( @ex.id ) }.should raise_error
end

Then /^the delete form fakes a DELETE with a hidden field$/ do
  last_response.should have_selector("input[name=\"_method\"][value=\"DELETE\"][type=\"hidden\"]")
end

