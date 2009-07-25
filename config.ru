require 'rubygems'
require 'sinatra'
require 'haml'
require 'config/env'
require 'app.rb'


FileUtils.mkdir_p 'log' unless File.exists?('log')
log = File.new("log/sinatra.log", "a")
$stdout.reopen(log)
$stderr.reopen(log)



use Rack::ContentLength

run Udon::Application
