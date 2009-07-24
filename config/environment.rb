require File.expand_path( File.dirname(__FILE__)) + '/boot'

Dir.entries( APP_ROOT + '/config/initializers/' ).each do |filename|
  file_path = File.join( APP_ROOT, 'config', 'initializers', filename )
  next unless File.file?( file_path ) && File.extname(file_path) == '.rb'
  load file_path
end

require 'udon/data'
require 'udon/account'
require 'udon/account_configuration'
require 'udon/collection_configuration'
require 'sinatra'
require 'haml'

