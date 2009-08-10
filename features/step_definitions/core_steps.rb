Given /an Example class is defined/ do
=begin
  Udon::Account.configure do |config|
    config.database = 'greenschools'
    config.collection :examples do
      text :email, :required => true
      checkboxes :roles, %w( Admin Creator Destroyer )
      select :state, %w( created pending complete ), :include_blank => true
      text_area :description, :class => 'minor'
    end
  end
=end
  require 'spec/fixtures/udon_example'
  class Example < UdonExample; end
end

Given /an example has been created/ do
  @ex = Example.create :email => 'edit@example.com', :state => 'complete'
end





