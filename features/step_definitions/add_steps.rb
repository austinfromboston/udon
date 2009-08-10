When /^I request the new example page$/ do
  get '/examples/new'
end

Then /^I see the new example form$/ do
  last_response.should have_selector("form[action='/examples']")
end
Then /selects are visible/ do
  last_response.should have_selector("select[name='state']")
end
Then /textareas are visible/ do
  last_response.should have_selector("textarea[name='description']")
end
Then /include_blank selects have an empty option/ do
  last_response.should have_selector("option[value='']:empty")
end
Then /classes from the configuration are in the html/ do
  last_response.should have_selector("textarea.minor")
end
Then /all fields have ids/ do
  last_response.should have_selector("textarea##{Example.config[:description].id}")
end

Then /the email is marked as required/ do
  last_response.should have_selector(".required input[name='email']")
end

Then /^the state select has options/ do
  last_response.should have_selector("select[name='state'] option[value='complete']")
  last_response.should have_selector("select[name='state'] option[value='pending']")
end

When /^I submit the new example form$/ do
  post '/examples', :email => 'test@example.com'
end

When /^I submit the new example form with invalid data$/ do
  post '/examples', :description => 'baloney'
end

Then /^I see a required field error message$/ do
  last_response.body.should match(/can't be empty/)
end

Then /^the problem field is highlighted/ do
  last_response.should have_selector(".error input[name*=email]")
end

When /^I request the examples index page$/ do
  get '/examples'
end

Then /^I should see the example I created$/ do
  last_response.body.to_s.should match( /test@example.com/ )
end

Then /^I see a link to edit the example$/ do
  last_response.should have_selector("a[href^='/examples/'][href$='/edit']")
end

Then /^I should see the examples list$/ do
  last_response.headers['Location'].should match( /examples$/ )
end

Then /the file upload element is visible/ do
  last_response.should have_selector("input[type=file]")
end

Then /the form is multipart/ do
  last_response.should have_selector("form[encoding='multipart/form-data']")
end
