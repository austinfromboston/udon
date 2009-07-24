require File.expand_path(File.dirname(__FILE__)+'/../../spec_helper')
require 'haml'

Udon::App.set :environment, :development

World do
  def app
    @app = Rack::Builder.new do
      run Udon::App
    end
  end
  include Rack::Test::Methods
  include Webrat::Methods
  include Webrat::Matchers
end
