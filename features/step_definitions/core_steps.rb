Given /an Example class is defined/ do
  Udon::Account.configure do |config|
    config.database = 'greenschools'
    config.collection :examples do
      text :email
      checkboxes :roles, %w( Admin Creator Destroyer )
      select :state, :state_options
      text_area :description
    end
  end
end

Given /an example has been created/ do
  @ex = Example.create :email => 'edit@example.com'
end





