When /^I request the edit example page$/ do
  get "/examples/#{@ex.id}/edit"
end

Then /^I see existing data in the form$/ do
  get "/examples/#{@ex.id}/edit"
  last_response.should have_selector("input[value=\"#{@ex.email}\"]")
  last_response.should have_selector("option[value=\"#{@ex.state}\"][selected]")
end

Then /^the edit form points to the example url$/ do
  last_response.should have_selector("form[action=\"/examples/#{@ex.id}\"]")
end

When /^I send updates to the example$/ do
  put "/examples/#{@ex.id}", :email => 'updated@example.com', :roles => { :parent => 'Parent', :student => 'Student' }
end

When /^I send invalid updates to the example$/ do
  put "/examples/#{@ex.id}", :email => '', :roles => { :parent => 'Parent', :student => 'Student' }
end

Then /^I see the updated info in the list$/ do
  get "/examples"
  last_response.body.should match(/updated@example.com/)
end

Then /^the edit form fakes a PUT with a hidden field$/ do
  last_response.should have_selector("input[name=\"_method\"][value=\"PUT\"][type=\"hidden\"]")
end

Then /^the database contains the checkbox values$/ do
  fresh_ex = Example.find @ex.id
  fresh_ex.roles.size.should == 2
  fresh_ex.roles.should include("Parent")
  fresh_ex.roles.should include("Student")
end

Then /^there should be nothing in the list$/ do
  Example.count.should == 0
end
