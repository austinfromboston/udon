require File.expand_path( File.dirname(__FILE__)) + '/boot.rb'

Dir.entries( APP_ROOT + '/config/initializers/' ).each do |filename|
  file_path = File.join( APP_ROOT, 'config', 'initializers', filename )
  next unless File.file?( file_path ) && File.extname(file_path) == '.rb'
  load file_path
end

load 'udon/data.rb'
load 'udon/account.rb'
load 'udon/uploaders/file_uploader.rb'
load 'udon/account_configuration.rb'
load 'udon/collection_configuration.rb'
load 'udon/form_helper.rb'
load 'udon/route_helper.rb'
load 'udon/resource_helper.rb'

class Sinatra::Reloader < Rack::Reloader 
  def safe_load(file, mtime, stderr = $stderr) 
    if file == Udon::Application.app_file 
      ::Udon::Application.reset! 
      stderr.puts "#{self.class}: resetting routes" 
    end 
    super 
  end 
end 

