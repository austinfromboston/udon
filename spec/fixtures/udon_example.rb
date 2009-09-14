#Udon::Account.configure "Green Schools" do |config|
Udon::Account.configure do |config|
  #config.akismet :key => 'value'
  config.database ='greenschools'
  state_options = ["Alabama","Alaska","Arizona","Arkansas","California","Colorado","Connecticut","Delaware","Florida","Georgia","Hawaii","Idaho","Illinois","Indiana","Iowa","Kansas","Kentucky","Louisiana","Maine","Maryland","Massachusetts","Michigan","Minnesota","Mississippi","Missouri","Montana","Nebraska","Nevada","New Hampshire","New Jersey","New Mexico","New York","North Carolina","North Dakota","Ohio","Oklahoma","Oregon","Pennsylvania","Puerto Rico","Rhode Island","South Carolina","South Dakota","Tennessee","Texas","Utah","Vermont","Virginia","Washington","Washington D.C.","West Virginia","Wisconsin","Wyoming"]
      
  config.collection :udon_examples do
    text :email, :required => true
    text :first_name
    text :last_name
    text :zip
    select :state, %w( created pending complete ), :include_blank => true
    text_area :description, :class => 'minor'
    checkboxes :roles, %w( Parent Student Teacher Other )
    text :other_role
    file :report
    #captcha
  end

  config.collection :propositions do

  end

  config.service :democracy_in_action do |dia|
    dia.login = "demo"
    dia.password = "demo"
    dia.node     = :sandbox
  end
end
