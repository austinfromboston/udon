#Udon::Account.configure "Green Schools" do |config|
Udon::Account.configure do |config|
  #config.akismet :key => 'value'
  config.database ='greenschools'
  config.collection :subscriptions do
    text :email #, :required => true
    text :first_name
    text :last_name
    text :zip
    checkboxes :roles, %w( Parent Student Teacher Other )
    text :other_role
    select :state, :state_options
    text_area :description
    #captcha
  end
end
