Udon is a flexible ludicrous-speed prototyping system built on Sinatra and MongoDB.  You supply a configuration file specified using the Udon DSL, which describes both the display and the model for very simple applications.  

Udon applications serve as live prototypes that can be updated by changing a single file.  A goal of this project is to offer the capability to "print" the generated application into code for Rails or Sinatra once the prototyping phase is complete.


An example of an Udon configuration file:


	Udon::Account.configure do |config|
	  config.akismet :key => 'value'
	  state_options = ["Alabama","Alaska","Arizona","Arkansas","California","Colorado","Connecticut","Delaware","Florida","Georgia","Hawaii","Idaho","Illinois","Indiana","Iowa","Kansas","Kentucky","Louisiana","Maine","Maryland","Massachusetts","Michigan","Minnesota","Mississippi","Missouri","Montana","Nebraska","Nevada","New Hampshire","New Jersey","New Mexico","New York","North Carolina","North Dakota","Ohio","Oklahoma","Oregon","Pennsylvania","Puerto Rico","Rhode Island","South Carolina","South Dakota","Tennessee","Texas","Utah","Vermont","Virginia","Washington","Washington D.C.","West Virginia","Wisconsin","Wyoming"]
	  config.database ='greenschools'
	  config.collection :subscriptions do
		%%[We promise never to release yr email to anybody]%
		text :email, :required => true
		text :first_name
		text :last_name
		text :zip
		checkboxes :roles, %w( Parent Student Teacher Other )
		text :other_role
		select :state, state_options, :include_blank => true
		text_area :description, :class => :minor
		file :report
		captcha
		
		notify :democracy_in_action, :as => 'supporter'
	  end

	  config.service :democracy_in_action do |dia|
		dia.login = "demo"
		dia.password = "demo"
		dia.node = :sandbox
	  end

	  
	end
