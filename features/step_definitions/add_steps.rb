When /^I request the new example page$/ do
  get '/examples/new'
end

Then /^I see the new example form$/ do
  last_response.should have_selector("form[action='/examples']")
  last_response.should have_selector("select[name='state']")
  last_response.should have_selector("textarea[name='description']")
end

When /^I submit the new example form$/ do
  post '/examples', :email => 'test@example.com'
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
