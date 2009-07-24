APP_ROOT = File.expand_path( File.dirname(__FILE__)) + '/..'
[ APP_ROOT, "#{APP_ROOT}/lib", "#{APP_ROOT}/app/models" ].each { |dir| $LOAD_PATH.unshift dir }

=begin
class Application
  @@env = 'development'
  def self.env
    @@env
  end
  def self.env=(value)
    @@env=value
  end
end
if ENV["RACK_ENV"]
  Application.env = ENV["RACK_ENV"]
end
=end

require 'rubygems'
require 'mongomapper'
require 'active_support'
