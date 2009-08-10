ENV["RACK_ENV"] = "test"
require 'rubygems'
require 'sinatra'
require File.expand_path( File.dirname(__FILE__)) + '/../config/env'
require 'spec'


Spec::Runner.configure do |config|
  def helper_proxy(*helper_modules)
    helper_class = Class.new do
      helper_modules.each do |mod_help|
        include mod_help
      end
      def params
        { :collection => 'udon_examples' }
      end
    end
    helper_class.new
  end
end
