require File.expand_path(File.dirname(__FILE__)+'/../../spec/spec_helper')
require 'haml'
require 'rack/test'
require 'webrat'
require APP_ROOT + '/app'

Udon::Application.set :environment, :development
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
    config.mode = :sinatra
  end

end
