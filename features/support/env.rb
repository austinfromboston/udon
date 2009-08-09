require File.expand_path(File.dirname(__FILE__)+'/../../spec/spec_helper')
require 'haml'
require 'rack/test'
require 'webrat'
require APP_ROOT + '/app'

Udon::Application.set :environment, :test
Udon::Application.set :show_exceptions, false
World do
  def app
    @app = Rack::Builder.new do
      run Udon::Application
    end
  end
  include Rack::Test::Methods
  include Webrat::Methods
  include Webrat::Matchers
  Webrat.configure do |config|
    config.mode = :rack
  end


end
